document.addEventListener("DOMContentLoaded", function() {
    // Function to increment view count
    function incrementViewCount() {
        // Retrieve the page ID from the query parameters
        const urlParams = new URLSearchParams(window.location.search);
        const pageId = urlParams.get('pageId');
        if (!pageId) {
            console.error('Page ID is missing');
            return;
        }

        // Send a request to your API Gateway endpoint with page ID to increment view count
        fetch('https://your-api-gateway-url.execute-api.your-region.amazonaws.com/prod/increment-view-count', {
            method: 'POST',
            body: JSON.stringify({ pageId: pageId }),
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            console.log('View count incremented successfully');
        })
        .catch(error => {
            console.error('Error incrementing view count:', error);
        });
    }

    // Call incrementViewCount function when the page is loaded
    incrementViewCount();
});