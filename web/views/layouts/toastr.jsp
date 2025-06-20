
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        <%
        String flashSuccess = (String) session.getAttribute("flash_success");
        String flashError = (String) session.getAttribute("flash_error");
        session.removeAttribute("flash_success");
        session.removeAttribute("flash_error");
        %>
        toastr.options = {
            closeButton: true,
            progressBar: true,
            positionClass: "toast-top-right",
            timeOut: "5000"
        };
        <% if (flashError != null) { %>

        toastr.error("<%= flashError %>", "Lỗi");
        <% } %>
        <% if (flashSuccess != null) { %>
        toastr.success("<%= flashSuccess %>", "Thành công");
        <% } %>
    });
</script>

