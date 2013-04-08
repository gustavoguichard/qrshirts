var QRShirts = window.QRShirts || {};

// If we already have the Admin namespace don't override
if (typeof QRShirts.Admin == "undefined") {
    QRShirts.Admin = {};
}
var kk = null;
// If we already have the purchaseOrder object don't override
if (typeof QRShirts.Admin.properties == "undefined") {

    QRShirts.Admin.properties = {
        //test    : null,
        initialize      : function( ) {
          // jQuery(".chzn-select").chosen();
          jQuery(".chzn-select").data("placeholder","Select Properties...").chosen();
        }
    };

    jQuery(function() {
      QRShirts.Admin.properties.initialize();
    });
}
