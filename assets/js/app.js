
function shareLink(link, e) {
    window.open(link.href, 'sharewindow','toolbar=0,status=0,width=626,height=436');
    if (e.stopPropagation) e.stopPropagation();
    if (e.preventDefault) e.preventDefault();
    return false;
}

$(function() {
    $(window).on('keyup', function(e) {
        if (e.keyCode == 71) {
            var cls = 'gridOverlay';
            var div = $('.'+cls)
            if (div.length) {
                div.remove()
            } else {
                $(document.body).append('<div class="'+cls+'"></div>');
            }
        }
    });

    /*
    // TEMP Header image rotation
    var classes = [
        'bigdata',
        'mobile',
        'trustedapps',
        'joinus'
    ];
    var index = 0;
    $('#main').on('click', function() {
        $(this).removeClass(classes.join(' ')).addClass(classes[++index % classes.length]);
    });
    */
});

