$(document).ready(function () {
    $(".tab_content").hide(); //Hide all content
    setActiveTab("Personal Infomation");

    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(this).addClass("active"); //Add "active" class to selected tab
        $(".tab_content").hide(); //Hide all tab content
        var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
        $(activeTab).fadeIn(); //Fade in the active content
        //$(activeTab).show(); 
        window.focus();
        return false;
    });

    $("table").tablesorter({ dateFormat: "uk" });
    $(".tablesorter tr:even").addClass("alt");



    $(function () {
        $("#HistoryContent h3.expand").toggler();
        $("#HistoryContent div.HistoryDiv").expandAll({ trigger: "h3.expand", ref: "h3.expand" });
    });

    uploader = new qq.FileUploader({
        element: document.getElementById('candidate_photofile'),
        action: '/uploadfile.mvc/SaveFile',
        allowedExtensions: ['jpg', 'jpeg', 'jpe', 'png', 'gif'],
        sizeLimit: 100000,
        params: {
            guid: getGUID()
        },
        onComplete: function (id, fileName, responseJSON) {
            if (jQuery.trim(responseJSON) == "1") {
                reloadICPhoto(fileName, getGUID());
                $("#candidate_photo").val(getGUID() + "_" + fileName);
            }
        }
    });
    var geocode = new SDGeocode();
    var keyword = "410651";
    var searchOption = { "q": keyword, "d": 1, "limit": 1 };
    var gc = SDGeocode.SG;
    geocode.requestData(gc, searchOption); 
});

function mycallBack(myvalue) {
    alert(myvalue);
}

function setActiveTab(tabname) {
    if (tabname == "Personal Infomation") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }
    window.focus();
}