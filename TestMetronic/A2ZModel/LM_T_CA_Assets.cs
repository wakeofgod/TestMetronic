using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class LM_T_CA_Assets:BaseModel
    {
        [Display(Name = "名称"), MaxLength(40), Required]
        public string Name { get; set; }
        [Display(Name = "公司"), Required]
        public int CompanyID { get; set; }
        //设备照片,可以为空
        public byte[] AssetInfo { get; set; }
        //照片格式
        public string InfoType { get; set; }
        //物理地址
        public string InfoUrl { get; set; }

        [Display(Name = "描述"), MaxLength(500), Required]
        public string  Description { get; set; }
        [Display(Name = "所有者"), MaxLength(500), Required]
        public Guid AssetOwner { get; set; }
        [Display(Name = "制造商"), Required]
        public Guid Manufacturer { get; set; }
        [Display(Name = "当前位置"), Required]
        public Guid CurrentLocation { get; set; }
        [Display(Name = "存放位置"), Required]
        public Guid StorageLocation { get; set; }
        [Display(Name = "工具类型"), Required]
        public Guid Type { get; set; }
        [Display(Name = "状态"), Required]
        public int Status { get; set; }

        public DateTime DateAcquired { get; set; }
    }
}