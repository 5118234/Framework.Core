using Framework.Core.IRepository;
using Framework.Core.IRepository.IUnitOfWork;
using Framework.Core.Models;
using Framework.Core.Models.ViewModels;
using Framework.Core.Repository.Base;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Framework.Core.Repository
{
    public class BlogLinksRepository : BaseRepository<BlogLinks>, IBlogLinksRepository
    {
        public BlogLinksRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {

        }
    }
}
