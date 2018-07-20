using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TestMetronic
{
    public class ReportViewHistory:BaseModel
    {
        [Required]
        [Display(Name = "Report")]
        public Guid Report { get; set; }

        [Required]
        [Display(Name = "查看人")]
        public int UserID { set; get; }

        [Required]
        [Display(Name = "查看人当前所属公司")]
        public int CompanyID { set; get; }

        [Required]
        [Display(Name = "查看时间")]
        public DateTime Time { set; get; }
    }
}