const config = {
    startOnLoad: true,
    flowchart: { useMaxWidth: true, htmlLabels: true, curve: 'cardinal' },
    securityLevel: 'loose',
};

document.addEventListener('DOMContentLoaded', function() {
    mermaid.initialize(config);
});

function autoRefresh() {
    window.location = window.location.href;
}
setInterval('autoRefresh()', 30000);