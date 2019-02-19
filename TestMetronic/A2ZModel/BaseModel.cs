using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace TestMetronic
{
    public class BaseModel
    {
        /// <summary>
        /// 数据编号
        /// </summary>
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid ID { get; set; }

        /// <summary>
        /// 是否删除
        /// </summary>
        [Required]
        public bool IsDelete { get; set; }

        /// <summary>
        /// 是否启用
        /// </summary>
        [Required]
        public bool IsEnable { get; set; }

        /// <summary>
        /// 其他唯一标识
        /// </summary>
        public long? OtherKey { get; set; }
    }
    public enum ENcrStatus
    {
        [Description("Created")]
        Created,
        [Description("CA Submitted")]
        CASubmitted,
        [Description("CAR Submitted")]
        CARSubmitted,
        [Description("Closed")]
        Closed
    }
}