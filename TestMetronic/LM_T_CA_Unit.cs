using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class LM_T_CA_Unit:BaseModel
    {
        [Display(Name = "元件名称"), Required]
        public string Name { get; set; }
        [Display(Name = "数量"), Required]
        public int UnitNumber { get; set; }
        [Display(Name = "创建人"), Required]
        public Guid CreateBy { get; set; }
        [Display(Name = "当前公司"), Required]
        public int CompanyId { get; set; }
        [Display(Name = "创建时间"), Required]
        public DateTime CreateTime { get; set; }
    }
}