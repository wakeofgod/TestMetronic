using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class AnalyCalendar:BaseModel
    {
        [Required]
        [Display(Name ="年")]
        public int Year { get; set; }

        [Required]
        [Display(Name ="月")]
        public int Month { get; set; }

        //每月起始时间，可以设置，不一定是第一天
        [Required]
        [Display(Name ="起始时间")]
        public DateTime StartDate { get; set; }

        //关联的字段
        [Required]
        public int ClientId { get; set; }

    }
}