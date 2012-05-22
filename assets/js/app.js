
function shareLink(link, e) {
    window.open(link.href, 'sharewindow','toolbar=0,status=0,width=626,height=436');
    if (e.stopPropagation) e.stopPropagation();
    if (e.preventDefault) e.preventDefault();
    return false;
}

$(function() {
    
    // USER POPUP
    var userImageRegex = /assets\/images\/users\/(.*)\.png/;
    var userPopupTimer;
    var removeBios = function() {
        var bios = $('.bio-popup').removeClass('show_bio')
        setTimeout(function() { bios.remove(); }, 500);
        $('img.loading').removeClass('loading')
    }
    $(document.body).on(
        {
            'mouseover': function(e) {

                var img = e.target
                var match = img && img.src && img.src.match(userImageRegex)
                var user = match && match.length == 2 && match[1]

                clearTimeout(userPopupTimer)
                if (user && $(img).parents('.bio-popup').length === 0) {
                    console.log('mouseon')
                    userPopupTimer = setTimeout(function() {
                        $(img).addClass('loading')
                        var show = function(text) {
                                var cap = $('<div class="bio-popup"/>').html(text)
                                var image = $(img)
                                var offset = image.offset()
                                var bump = (75 - offset.height) / 2 + 10 // center image (10=border)

                                delete offset.height
                                offset.width = '300px'
                                offset.left -= +bump
                                offset.top -= +bump
                                
                                removeBios()
                                $(document.body).append(
                                    cap.append(image.clone().attr({width:'75px',height:'75px'})).css(offset)
                                )

                                setTimeout(function() { cap.addClass('show_bio') }, 10)
                        };
                        $.ajax({
                            url: '/short_bios/popup_bio/'+user+'.html',
                            success: function(response){
                                show(response);
                            },
                            error: function() {
                                show('<hgroup></hgroup><section class="about">No information available</section>');
                            }
                        });
                    }, 250);
                }   
            },
            'mouseout': function(e) {
                var to = e.relatedTarget || e.toElement;

                // Return if mousing to the popup image
                if (to && $(to).parents('.bio-popup').length)
                    return

                console.log('mouseout', to)
                clearTimeout(userPopupTimer)
                removeBios()
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
