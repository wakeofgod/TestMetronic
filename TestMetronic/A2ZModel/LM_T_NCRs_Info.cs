using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TestMetronic.A2ZModel
{
    public class LM_T_NCRs_Info :BaseModel
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int NCRNo { get; set; }
        [Display(Name = "上传用户")]
        [Required]
        public int User { get; set; }
        [Display(Name = "公司ID")]
        [Required]
        public int CompanyID { get; set; }
        [Display(Name = "状态")]
        [Required]
        public ENcrStatus Status { get; set; }

        //ncr导入新加字段
        public long? ImportNo { get; set; }
        public int? ImportIndex { get; set; }
        public int? SupplierID { get; set; }
    }
}