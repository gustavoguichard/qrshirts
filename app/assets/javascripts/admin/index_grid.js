var QRShirts = window.QRShirts || {};

QRShirts.AdminIndexForm = {
  registerOnLoadHandler : function(callback) {
    jQuery(window).ready(callback);
  },
  initialize : function(controller) {
    this.formController = controller;
  }, 
  editSelection : function(id) {
    window.location.href = QRShirts.AdminIndexForm.formController+'/'+id+"/edit";
  },
  showSelection : function(id) {
    window.location.href = QRShirts.AdminIndexForm.formController+'/'+id;
  },
  userSelection : function(id) {
    jQuery('#admin-user_id').val(id);  
    jQuery('#admin-user-form').submit();
  },
  newShipmentSelection : function(id) {
    window.location.href = QRShirts.AdminIndexForm.formController+'/'+id+"/shipments/new";
  }
}