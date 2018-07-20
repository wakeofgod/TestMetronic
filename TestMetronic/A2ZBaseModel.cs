using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TestMetronic
{
    public class A2ZBaseModel
    {
        [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public Guid ID
        {
            get;
            set;
        }

        [Required]
        public bool IsDelete
        {
            get;
            set;
        }

        [Required]
        public bool IsEnable
        {
            get;
            set;
        }
    }
}