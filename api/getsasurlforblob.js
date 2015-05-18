var azure = require('azure');
var qs = require('querystring');


exports.get = function(request, response) {

    // en el parametro nos llega el nombre del blob
    var blobName = request.query.blobName;
    
    var accountName = "scoopsstorage";
    
    var accountKey =  "cs/aFnN9rBDBGKGIlRjEBMt8HsyqLGn2BtbvOGdjoTZydZJEFgc7aNpZhOCH8w0BXd3ikGPfyXTe8LkFcIqGcg==";
    
    var host = accountName + '.blob.core.windows.net/'
    
    var blobService = azure.createBlobService(accountName, accountKey, host);
    
    var sharedAccessPolicy = { 
        AccessPolicy : {
            Permissions: 'rw',
            Expiry: minutesFromNow(15)
        }
    };
    
     var sasURL = blobService.generateSharedAccessSignature('scoopimages', blobName, sharedAccessPolicy);
    
    console.log('SAS ->' + sasURL);
    
     var sasQueryString = { 'sasUrl' : sasURL.baseUrl + sasURL.path + '?' + qs.stringify(sasURL.queryString) };
    request.respond(200, sasQueryString);
};

function formatDate(date) { 
    var raw = date.toJSON(); 
    // Blob service does not like milliseconds on the end of the time so strip 
    return raw.substr(0, raw.lastIndexOf('.')) + 'Z'; 
} 

function minutesFromNow(minutes) {
    var date = new Date()
  date.setMinutes(date.getMinutes() + minutes);
  return date;
}