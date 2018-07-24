using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class AnalySetting:BaseModel
    {
        ////guid
        //[Required]
        //[Display(Name = "Setting")]
        //public Guid Setting { get; set; }

        //开关，是否共享,取值0,1
        [Required]
        [Display(Name = "共享")]
        public bool IsShare { get; set; }

        //放在子表里
        ////对应的日历编号,对应的表dbo.dc_t_openbook_calendar,每选择一年，自动生成的12个月份数据
        //public int ClientID { get; set; }

        [Required]
        [Display(Name ="自定义时间是否启用")]
        public bool IsCalendarEnable { get; set; }
        [Required]
        [Display(Name = "设置人")]
        public int UserId { get; set; }

        //对应的公司，不要下划线
        [Required]
        [Display(Name = "设置人当前公司编号"),MaxLength(100)]
        public int CurrentCompanyId { get; set; }

        //对应的模版，可以有多个,如果不用集合，要用拼接字符串，取值的时候用split
        [Required]
        [Display(Name = "模版")]
        public List<string> TemplateList { get; set; }

        //同步数据，自动生成密码保存在数据库里
        [Required]
        [Display(Name = "密码"),MaxLength(50)]
        public string UploadPassword { get; set; }

        //[Display(Name ="创建时间")]
        //public DateTime CreateTime { get; set; }

        [Display(Name = "修改时间")]
        public DateTime LastUpdateTime { get; set; }

        public int LastUpdateBy { get; set; }     
    }
}