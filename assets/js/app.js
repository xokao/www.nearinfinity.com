
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
    var getUser = function(e) {
        var img = e.target
        var match = img && img.src && img.src.match(userImageRegex)
        var user = match && match.length == 2 && match[1]
        return user
    }
    $(document.body).on(
        {
            'mouseover': function(e) {
                var img = e.target
                var user = getUser(e)

                clearTimeout(userPopupTimer)
                if (user && $(img).parents('.bio-popup').length === 0) {
                    userPopupTimer = setTimeout(function() {
                        $(img).addClass('loading')
                        var show = function(text) {
                                var cap = $('<div class="bio-popup"/>').html(text)
                                var image = $(img)
                                var offset = image.offset()
                                var imageDimensions = { width:'75px', height:'75px' };
                                var bump = (parseInt(imageDimensions.height,10) - offset.height) / 2 + 10 // center image (10=border)

                                offset.width = '300px'
                                offset.left -= bump
                                offset.top -= bump

                                if ((offset.left + parseInt(offset.width, 10)) > $(window).width()) {
                                    cap.addClass('left');
                                    offset.left -= 300 - 75 - bump / 2
                                }
                                delete offset.height

                                removeBios()
                                $('<a href="/blogs/' + user + '"></a>').append(
                                    image.clone().attr(imageDimensions)
                                ).appendTo(cap.css(offset))
                                cap.appendTo(document.body)

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
                if (to && $(to).is('a img') && $(to).parents('.bio-popup').length)
                    return

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

// Picks random tech talk to show
$(function() {
  var talks = $('.homepage-techtalk');
  $(talks.get(Math.floor(Math.random()*talks.length))).show();
});
