function init(){
    $("center h1").hide();
    $("#submit").click(function(){
                       app.submit();
                       });
}

var app = {
    submit: function(){
        var uname = $("#uname").val(),
        pass = $("#pass").val(),
        creds = btoa(uname + ":" + pass),
        timeout = $("#timeout").val(),
        success = function(data, error, xhr){
            $("center h1").hide();
            alert("Success : " + xhr.status);
        },
        fail = function(xhr){
            $("center h1").hide();
            alert("Fail : " + JSON.stringify(xhr));
        };
        timeout = (timeout === "" ? 5 : timeout);
        $("center h1").show();
        $.ajax({
               url: 'http://ec2-54-234-54-74.compute-1.amazonaws.com/mediawiki/auth/auth.php',
               cache: false,
               beforeSend: function(xhr){
                xhr.setRequestHeader("Authorization", "Basic " + creds);
               },
               success: success,
               error: fail,
               timeout: (+timeout) * 1000
        });
    }
};
