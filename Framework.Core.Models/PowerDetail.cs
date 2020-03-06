﻿using SqlSugar;
using System;
using System.Collections.Generic;
using System.Text;

namespace Framework.Core.Models
{
    public class PowerDetail : RootEntity
    {
        /// <summary>
        /// 角色id
        /// </summary>
        [SugarColumn(IsNullable = false)]
        public string PowerName { get; set; }

        /// <summary>
        /// 功能ID
        /// </summary>
        [SugarColumn(IsNullable = false)]
        public int menuid { get; set; }
    }
}
