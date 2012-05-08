function shareLink(link, e) {
    window.open(link.href, 'sharewindow','toolbar=0,status=0,width=626,height=436');
    if (e.stopPropagation) e.stopPropagation();
    if (e.preventDefault) e.preventDefault();
    return false;
}

if (window.addEventListener) {
    window.addEventListener('keyup', function(e) {
        if (e.keyCode == 71) {
            var id = 'gridOverlay';
            var div = document.getElementById(id)
            if (div) {
                div.parentNode.removeChild(div);
            } else {
                div = document.createElement('div');
                div.id = id;
                div.className = id;
                document.body.appendChild(div);
            }
        }
    }, false);

    window.addEventListener('DOMContentLoaded', function() {
        var images = [
            'big-data-trans',
            'mobile',
            'trusted-apps',
            'join-us'
        ];
        var index = 1;
        document.getElementById('main').addEventListener('click', function() {
            var div = this.getElementsByTagName('figure')[0].childNodes[0]
            div.style.background = 'url(assets/images/impact/' + images[(++index % images.length)] + '.png) 15px 0px no-repeat'
        }, false);
    }, false);
}


