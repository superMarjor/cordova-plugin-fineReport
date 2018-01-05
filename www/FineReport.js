var exec = require('cordova/exec');

var FineReport = {
    showFromUrl : function(arg0, success, error){
        exec(success, error, "FineReport", "showFromUrl", [arg0]);
    },
    logInto : function(arg0, success, error){
        exec(success, error, "FineReport", "logInto", [arg0]);
    },
    isPad : function(arg0, success, error){
        exec(success, error, "FineReport", "isPad", [arg0]);
    }
}

module.exports = FineReport;

