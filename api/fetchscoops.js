exports.get = function(request, response) {
    
    // extract parameters
    var userID = request.user.userId;
    var authorID = request.query.authorID;
    var basic = request.query.basic; // new Boolean(request.query.basic) ;
    var published = request.query.published; // new Boolean(request.query.published);
    
    // create query
    var requested;
    if (basic === 'TRUE') {
        requested = "id, headline, authorname, photoURL, __createdAt ";
    } else {
        requested = "* "; // ALL
    }
    var filter = "where published = '" + published + "'";
    if (authorID) {
        filter = filter + " and authorId = '" + authorID + "'";
    }  
    var querySQL = "Select " + requested + "from scoops " + filter;
    console.log(querySQL);
    
    // fetch scoops
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