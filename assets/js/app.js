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
}
