﻿using Castle.DynamicProxy;
using Framework.Core.Common;
using Framework.Core.IRepository.IUnitOfWork;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Framework.Core
{
    public class FrameworkTranAOP : IInterceptor
    {
        private readonly IUnitOfWork _unitOfWork;
        public FrameworkTranAOP(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        /// <summary>
        /// 实例化IInterceptor唯一方法 
        /// </summary>
        /// <param name="invocation">包含被拦截方法的信息</param>
        public void Intercept(IInvocation invocation)
        {
            var method = invocation.MethodInvocationTarget ?? invocation.Method;
            //对当前方法的特性验证
            //如果需要验证
            if (method.GetCustomAttributes(true).FirstOrDefault(x => x.GetType() == typeof(UseTranAttribute)) is UseTranAttribute)
            {
                try
                {
                    _unitOfWork.BeginTran();

                    invocation.Proceed();

                    // 异步获取异常，先执行
                    if (IsAsyncMethod(invocation.Method))
                    {
                        if (invocation.Method.ReturnType == typeof(Task))
                        {
                            invocation.ReturnValue = InternalAsyncHelper.AwaitTaskWithPostActionAndFinally(
                                (Task)invocation.ReturnValue,
                                async () => await TestActionAsync(invocation),
                                ex =>
                                {
                                    _unitOfWork.RollbackTran();
                                });
                        }
                        else //Task<TResult>
                        {
                            invocation.ReturnValue = InternalAsyncHelper.CallAwaitTaskWithPostActionAndFinallyAndGetResult(
                             invocation.Method.ReturnType.GenericTypeArguments[0],
                             invocation.ReturnValue,
                             async () => await TestActionAsync(invocation),
                             ex =>
                             {
                                 _unitOfWork.RollbackTran();

                             });
                        }
                    }
                    _unitOfWork.CommitTran();

                }
                catch (Exception)
                {
                    _unitOfWork.RollbackTran();
                }
            }
            else
            {
                invocation.Proceed();//直接执行被拦截方法
            }

        }

        public static bool IsAsyncMethod(MethodInfo method)
        {
            return (
                method.ReturnType == typeof(Task) ||
                (method.ReturnType.IsGenericType && method.ReturnType.GetGenericTypeDefinition() == typeof(Task<>))
                );
        }
        private async Task TestActionAsync(IInvocation invocation)
        {
            await Task.Delay(0);
        }
    }
}
