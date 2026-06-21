</div><!-- fine .main -->

<script>
    (function () {
        var toggle  = document.getElementById('sidebarToggle');
        var sidebar = document.getElementById('adminSidebar');
        var overlay = document.getElementById('sidebarOverlay');

        if (!toggle || !sidebar || !overlay) return;

        function openSidebar() {
            sidebar.classList.add('is-open');
            overlay.classList.add('is-open');
        }
        function closeSidebar() {
            sidebar.classList.remove('is-open');
            overlay.classList.remove('is-open');
        }

        toggle.addEventListener('click', function () {
            if (sidebar.classList.contains('is-open')) {
                closeSidebar();
            } else {
                openSidebar();
            }
        });

        overlay.addEventListener('click', closeSidebar);

        // Chiude il drawer quando si seleziona una voce di menu (utile su mobile)
        var links = sidebar.querySelectorAll('nav a');
        for (var i = 0; i < links.length; i++) {
            links[i].addEventListener('click', closeSidebar);
        }
    })();
</script>

</body>
</html>
