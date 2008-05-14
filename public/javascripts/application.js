// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
/* http://railscasts.com/episodes/77 */
function confirm_destroy(element, action, confirm_message, auth_token) {
  if (confirm(confirm_message)) {
    var f = document.createElement('form');
    f.style.display = 'none';
    element.parentNode.appendChild(f);
    f.method = 'POST';
    f.action = action;
    var m = document.createElement('input');
    m.setAttribute('type', 'hidden');
    m.setAttribute('name', '_method');
    m.setAttribute('value', 'delete');
    f.appendChild(m);
		var t = document.createElement('input');
		t.setAttribute('type', 'hidden');
		t.setAttribute('name', 'authenticity_token');
		t.setAttribute('value', auth_token);
		f.appendChild(t);
		console.log(f);
    f.submit();
  }
  return false;
}