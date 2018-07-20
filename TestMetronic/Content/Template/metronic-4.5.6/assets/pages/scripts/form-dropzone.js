var FormDropzone = function () {


    return {
        //main function to initiate the module
        init: function () {  

            Dropzone.options.myDropzone = {
                dictDefaultMessage: "",
                positiontype: 2,
                paramName: "file",  
                maxFilesize:1,//MB
                acceptedFiles: ".png,.jpg,.jpeg",  
                uploadMultiple: false,
                
                //remove°´Å¥
                //init: function() {
                //    this.on("addedfile", function(file) {
                //        // Create the remove button
                //        var removeButton = Dropzone.createElement("<a href='javascript:;'' class='btn red btn-sm btn-block'>Remove</a>");
                        
                //        // Capture the Dropzone instance as closure.
                //        var _this = this;

                //        // Listen to the click event
                //        removeButton.addEventListener("click", function(e) {
                //          // Make sure the button click doesn't submit the form:
                //          e.preventDefault();
                //          e.stopPropagation();

                //          // Remove the file preview.
                //          _this.removeFile(file);
                //          // If you want to the delete the file on the server as well,
                //          // you can do the AJAX request here.
                //        });

                //        // Add the button to the file preview element.
                //        file.previewElement.appendChild(removeButton);
                //    });
                //},
                complete: function (file) {
                   
                    
                    var a = file.xhr.response;

                    var obj = $.parseJSON(a);//½âÎö
                    //    var sArr = a.split(",");

                    //    for (var i = 0; i <sArr.length; i++)
                    //{
                    //        singleFile1 = sArr[2];
                    //}  
                   
                    //    var sBrr = singleFile1.split(":");

                    //    for (var i = 0; i < sBrr.length; i++) {
                    //        singleFile2 = sBrr[1];
                    //    }
                    //    var sCrr = singleFile2.split("}");

                    //    for (var i = 0; i < sCrr.length; i++) {
                    //        singleFile = sCrr[0];
                    //    }

                    //    singleFile = singleFile.substring(1, singleFile.length - 1)
                    var objParam = new Object();
                    objParam.uploadFiles = obj.fileName;
                    objParam.delFiles = '';
                    objParam.uploadType = "image";

                    if (objParam.uploadFiles == '') {
                        alert(M82);
                        return;
                    }
                    AjaxRequest(window.website + "Company/Information/UploadDatasetIcon", objParam, function (json) {
                        if (!json.isSuccess) {
                         
                            var error = FormatString(M24, 'Upload') + (json.info ? ":" + json.info : "!"); 
                            alert(error);
                            
                        }
                        else {
                            if (json.imgContent) {
                                $("#imgPartEait").attr("src", "data:image/png;base64," + json.imgContent);
                                $("#imgPartEait1").attr("src", "data:image/png;base64," + json.imgContent);

                            }

                        } 
                    });
                 
                    //imgPartEait1
                },
                //queuecomplete: function () {
                //   alert("mm")
                //}
            }
        }
    };
}();

jQuery(document).ready(function() {    
   FormDropzone.init();
});