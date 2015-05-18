exports.get = function(request, response) {
    
    var scoopID = request.query.scoopID;
    var querySQL = "Select * from scoops where id = '" + scoopID + "'";
    console.log(querySQL);
    
    var mssql = request.service.mssql;
    mssql.query(querySQL, {
        success : function(result){
            response.send(200,result);
        },
        error : function(error){
            response.error(error);
        }
    });
};