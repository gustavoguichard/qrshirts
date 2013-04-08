var QRShirts = window.QRShirts || {};


QRShirts.Utility = {
  registerOnLoadHandler : function(callback) {
    jQuery(window).ready(callback);
  }
}


QRShirts.AdminMerchandiseProductForm = {

    productCheckboxesDiv  : '#product_properties',
    prototypeSelectId     : '#product_prototype_id',
    formController        : '/admin/merchandise/products',
    productId             : null,

    initialize : function(product_Id) {

      this.productId  = product_Id;
      var prototype       = jQuery(QRShirts.AdminMerchandiseProductForm.prototypeSelectId);
      prototype.
              bind('change',
                function() {
                  QRShirts.AdminMerchandiseProductForm.addProperties(
                    jQuery(QRShirts.AdminMerchandiseProductForm.prototypeSelectId + " option:selected").first().val()
                  );
                }
              );
    },
    addProperties : function(id) {
      if ( typeof id == 'undefined' || id == 0 ) {
        //  show all properties...
$('#product_properties').children().fadeIn();
        //jQuery(QRShirts.AdminMerchandiseProductForm.productCheckboxesDiv).html('');
      }
      else {
        jQuery.ajax( {
           type : "GET",
           url : MerchProductForm.formController+'/'+id+"/add_properties",
           data : { product_id : QRShirts.AdminMerchandiseProductForm.productId },
           complete : function(json) {
             // open dialog with html
             QRShirts.AdminMerchandiseProductForm.refreshProductForm(json);
            // STOP  WAIT INDICATOR...
           },
           dataType : 'json'
        });
      }
    },
    refreshProductForm : function(json) {
      // SHow the properties that are associated to this product

      //jQuery(MerchProductForm.productCheckboxesDiv).html(htmlText.responseText);
      // Show the save button
      //alert(json.responseText);
      properties = JSON.parse(json.responseText);
      //alert(properties.property[0])
      jQuery.each (properties.active, function(p,value) {
        jQuery('#property_' + value ).fadeIn();
      });

      jQuery.each (properties.inactive, function(p,value) {
        propertyId = '#property_' + value;
        jQuery(propertyId ).hide();
        jQuery(propertyId + ' input:text')[0].value = '';
      });
    }
};

MerchProductForm = QRShirts.AdminMerchandiseProductForm