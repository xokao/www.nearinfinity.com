
function shareLink(link, e) {
    window.open(link.href, 'sharewindow','toolbar=0,status=0,width=626,height=436');
    if (e.stopPropagation) e.stopPropagation();
    if (e.preventDefault) e.preventDefault();
    return false;
}

$(function() {
    console.log('b');

    
    // USER POPUP
    var userImageRegex = /assets\/images\/users\/(.*)\.png/;
    var userPopupTimer;
    $(document.body).on(
        {
            'mouseover': function(e) {

                var img = e.target;
                var match = img && img.src && img.src.match(userImageRegex);
                var user = match && match.length == 2 && match[1];

                clearTimeout(userPopupTimer);
                if (user && $(img).parents('.bio-popup').length === 0) {
                    // Start loading html
                    var doneLoading = false, doneWaiting = false;
                    var addToPage = function() {
                        cap.append($(img).clone());
                        var offset = $(img).offset()
                        delete offset.height;
                        offset.width = Math.max(275, offset.width);
                        offset.left -= 12;
                        offset.top -= 12;
                        console.log(offset);
                        $(document.body).append(cap.css(offset));
                    };
                    var cap = $('<div class="bio-popup"/>').load('/short_bios/popup_bio/'+user+'.html', function() {
                        doneLoading = true;
                        if (doneWaiting) addToPage();
                    });

                    userPopupTimer = setTimeout(function() {
                        doneWaiting = true;
                        if (doneLoading) addToPage();

                        /*
                        var figure = $(img).parent('figure');
                        if (figure.length) {
                            figure.find('figcaption').show();
                            figure.addClass('show_bio');
                        } else {
                            var cap = $('<figcaption/>').load('/short_bios/popup_bio/'+user+'.html', function() {
                                figure = $(img).wrap('<figure class="user_popup" />').parent()
                                figure.append(cap);
                                setTimeout(function() {
                                    cap.show();
                                    figure.addClass('show_bio');
                                }, 10);
                            });
                        }
                        */
                    }, 250);
                }   
            },
            'mouseout': function(e) {
                clearTimeout(userPopupTimer);
                $('.bio-popup').remove()
                /*
                $('figure.user_popup.show_bio figcaption').on('webkitTransitionEnd', function() {
                    $(this).hide().off('webkitTransitionEnd');
                })
                $('figure.user_popup.show_bio').removeClass('show_bio');
                */
            } 
        },
        'img'
    );


    // DEBUG CODE
    if (window.location.hostname == 'localhost') {

        // SHOW GRID OVERLAY
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
    }
});

