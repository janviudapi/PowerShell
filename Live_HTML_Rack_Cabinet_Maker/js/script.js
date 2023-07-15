// Start button navbar //
function openNav() {
    document.getElementById("mySidebar").style.width = "250px";
    document.getElementById("main").style.marginLeft = "250px";
}

function closeNav() {
    document.getElementById("mySidebar").style.width = "0";
    document.getElementById("main").style.marginLeft= "0";
}
// Stop button navbar //

// --- references information--- //
const referencesBox = document.getElementById('references');

// --- Header Info --- //
let tableHeaderNames = ['U', 'Rack1', 'U']; 

let tableCabinets = document.getElementById('tableCabinets');
// let tableCabinets = document.querySelector('#tableCabinets');
// tableCabinets.innerHTML = '';
let tableHead = tableCabinets.querySelector('thead');
let tableHeaderRow = document.createElement('tr'); //Add first table header row

tableHeaderNames.forEach((headName) => {
        let tableHeader = document.createElement('th'); //Add first table header cell
        tableHeader.style.color = 'White';
        tableHeader.style.backgroundColor = 'coral';
        // tableHeader.style.border = '1px solid darkgray';
        tableHeader.textContent = headName;
        tableHeaderRow.appendChild(tableHeader);
});

tableHead.appendChild(tableHeaderRow);
//tableCabinets.appendChild(tableHeadWhole);

fetch('dbase/serverData.json?timestamp=${Date.now()}', {
    cache: 'no-store' // Set cache to 'no-store' to prevent caching
})
//.then(response => response.json())
.then(response => {
    // Create a new Headers object and set cache control headers
    const headers = new Headers(response.headers);
    headers.append('Cache-Control', 'no-cache, no-store, must-revalidate');
    headers.append('Pragma', 'no-cache');
    headers.append('Expires', '0');

    // Create a new Response object with updated headers
    const updatedResponse = new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: headers
    });
    return updatedResponse.json();
})
.then(jsonData => {
        // --- Body Info --- //
        let tableBody = tableCabinets.querySelector('tbody');

        // Logic for rack unit 0 with bookmark
        let idOfNextObject = null;
        let foundZero = false;

        //sort and for
        jsonData.sort((unitA, unitB) => unitB.unitId - unitA.unitId).forEach((server) => {   // Reverse - // jsondata.reverse().forEach((server) => { // sort - // sort((unitA, unitB) => unitB.unitId - unitA.unitId).

        //tr creation
        const tableBodyRow = document.createElement('tr');
        //deskElement.classList.add('desk');
        
        //first table creation
        const unit1 = document.createElement('td');
        unit1.innerHTML =   `<strong>: ${server.unitId}</strong>`; // ":  " + server.unitId;
        unit1.classList.add('tightunit');
        
        tableBodyRow.appendChild(unit1);
        
        //show table correctly
        if (server.unitSize >= 1) 
        {
            const serverInfo = document.createElement('td');
            var unitIdBookMark = "unitId" + server.unitId;
            serverInfo.id = unitIdBookMark;

            if (server.isEmpty == 'yes') {
                serverInfo.innerHTML = "<strong>EMPTY SLOT</strong>";
                serverInfo.style.backgroundColor = "DarkGray";
                serverInfo.style.color = "White";
            } //if (server.isEmpty == 'yes') {
            else
            {   
                let tdDivPopTrigger= "tdDivPoptrigger" + server.unitId;
                let tdDivShowPopupBox = "tdDivShowPopBox" + server.unitId;
                //let tdDivImgStatusPopTrigger= "tdDivImgStatusPopTrigger" + server.unitId;
                let imgInfoIconTrigger = "imgInfoIconTrigger" + server.unitId;

                let tdDivBeforeImg= "tdDivBeforeImg" + server.unitId;
                let imgIcon = `<img id="${tdDivBeforeImg}" src="img/${server.objectType}.png" alt="Network Switch" width="24px" height="24px">`;
                let imgInfoIcon = `<img id="${imgInfoIconTrigger}" src="img/information.png" alt="Network Switch" width="24px" height="24px">`;
                let serverStatus = `<img src="img/circle/${server.serverinfo.status}.png" alt="up" width="24px" height="24px">`;
                serverInfo.innerHTML = `<div class="tdDiv" id="${tdDivPopTrigger}"> ${imgIcon} &nbsp; &nbsp; &nbsp;  ${serverStatus} &nbsp; &nbsp; &nbsp; ${imgInfoIcon} &nbsp; &nbsp; &nbsp; <strong>${server.serverinfo.servername}</strong><div id="${tdDivShowPopupBox}" style="display: none;"></div></div>`; 
                serverInfo.style.backgroundColor = server.unitColor;
            } //else
            
            serverInfo.style.textAlign = 'left';
            serverInfo.setAttribute('rowspan', server.unitSize);
            // serverInfo.rowSpan = server.unitSize > 0 ? server.unitSize : 1;
            tableBodyRow.appendChild(serverInfo);

            // Showing popup http://vcloud-lab.com
            // document.addEventListener("DOMContentLoaded", function() {
            //     let tdDivPopTrigger = "tdDivPoptrigger" + server.unitId;
            //     let tdShowPopupBox = "tdDivShowPopBox" + server.unitId;
            //     let divPopTrigger = document.getElementById(tdDivPopTrigger);
            //     let divShowPopBox = document.getElementById(tdShowPopupBox);

            //     divShowPopBox.addEventListener("mouseenter", function() {
            //         // Add your code here to show the popup box or perform any other actions
            //         divShowPopBox.textContent = "This is a popup box!";
            //         // You can show the popup box, update its content, or perform any other desired actions
            //         // Position the popup box relative to the div element
            //         var rect = divPopTrigger.getBoundingClientRect();
            //         divShowPopBox.style.top = rect.top + "px";
            //         divShowPopBox.style.left = rect.left + "px";

            //         // Display the popup box
            //         divShowPopBox.style.display = "block";
            //     });

            //     // Add the event listener for the mouseleave event
            //     divPopTrigger.addEventListener("mouseleave", function() {
            //         // Hide the popup box
            //         divShowPopBox.style.display = "none";
            //     });
            // });


        } //if (server.unitSize >= 1)

        const unit2 = document.createElement('td');
        unit2.innerHTML = `<strong>${server.unitId} :</strong>`;
        unit2.classList.add('tightunit');
        tableBodyRow.appendChild(unit2);           
        unit2.style.textAlign = 'right';
        tableBody.appendChild(tableBodyRow); //last line add tr to tbody

        // side reference information
        const referenceDiv = document.createElement('div');
        referenceDiv.classList.add("unit" + server.unitId);
        referenceDiv.id = "unitB" + server.unitId;
        referenceDiv.metainfo = server.unitSize;
        referenceDiv.innerHTML = server.unitId;
        referenceDiv.style.margin = "5px";
        referenceDiv.style.padding = "5px";
        referenceDiv.style.color = "white";
        referenceDiv.style.backgroundColor = "tomato";
        referenceDiv.style.border = "1px solid coral";
        referenceDiv.style.borderRadius = "5px";
        referenceDiv.style.textAlign = "center";
        referenceDiv.style.width = "10px";
        
        referenceDiv.addEventListener("mouseenter", function() {
            this.style.cursor = "pointer";
        }); //http://127.0.0.1:3000/HTML/Server_Rack/index.html#unitId1
        referenceDiv.addEventListener("mouseleave", function() {
            this.style.cursor = "auto";
        });

        //multi unit bookmark configuration
        const bookmarkId = "unitId" + server.unitId;
        referenceDiv.addEventListener("click", function() {
            location.href = '#' + bookmarkId;
        });
        
        if (server.unitSize >= 1) //hide few
        {
            //http://vcloud-lab.com
            referencesBox.appendChild(referenceDiv);
        }
    }); //jsonData.sort((unitA, unitB) => unitB.unitId - unitA.unitId).forEach((server) => {
}); //.then(jsonData => {



fetch('dbase/serverData.json?timestamp=${Date.now()}', {
    cache: 'no-store' // Set cache to 'no-store' to prevent caching
})
//.then(response => response.json())
.then(response => {
    // Create a new Headers object and set cache control headers
    const headers = new Headers(response.headers);
    headers.append('Cache-Control', 'no-cache, no-store, must-revalidate');
    headers.append('Pragma', 'no-cache');
    headers.append('Expires', '0');

    // Create a new Response object with updated headers
    const updatedResponse = new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: headers
    });
    return updatedResponse.json();
})
.then(jsonData => {
    jsonData.sort((unitA, unitB) => unitB.unitId - unitA.unitId).forEach((server) => {
        let tdDivPopTrigger= "tdDivPoptrigger" + server.unitId;  //div inside td hover effect
        let imgInfoIconTrigger = "imgInfoIconTrigger" + server.unitId; //information png icon click effect
        let tdDivShowPopupBox = "tdDivShowPopBox" + server.unitId; //div show pop up

        let triggerIcon = document.querySelector("#" + imgInfoIconTrigger);
        let popupDiv = document.querySelector("#" + tdDivShowPopupBox);
        
        if (triggerIcon !== null)
        {
            popupDiv.style.position = 'fixed';
            popupDiv.style.top = '50%';
            popupDiv.style.left = '60%';
            popupDiv.style.transform = 'translate(-50%, -50%)';
            //popupDiv.style.color = 'white';
            //popupDiv.style.background = 'linear-gradient(225deg, #FF3CAC 0%, #784BA0 50%, #2B86C5 100%)';
            popupDiv.style.background = '#fff';
            popupDiv.style.backgroundColor = '#fff';
            popupDiv.style.border = '1px solid gray';
            popupDiv.style.borderRadius = '10px';
            popupDiv.style.padding = '10px';
            popupDiv.style.zIndex = '9999';
            popupDiv.style.minWidth = '300px';
            popupDiv.style.minHeight = '200px';

            let cpu = Math.floor(Math.random() * 91) + 10;
            let ram = Math.floor(Math.random() * 91) + 10;

            const tableContent = `
                <p>Click icon to copy information</p>
                <h3>${server.serverName}</h3>
                <table><tr><th>Owner</th><th>Department</th></tr><tr><td>${server.owner}</td><td>${server.department}</td></tr></table>
                <p><b>Purpose:</b> ${server.purpose}</p>
                <div class="pie" id="${server.serverName}cpu">20% <br><span style='font-size:20px'>Some Text</span></div>
                <div class="pie" id="${server.serverName}mem">20% <br><span style='font-size:20px'>Some Text</span></div>
            `;
            popupDiv.innerHTML = tableContent;

            function generatePieChart(id, percentage, color, additionalText) {
                const pieChart = document.getElementById(id);
                pieChart.style.setProperty('--p', percentage);
                pieChart.style.setProperty('--c', color);
                pieChart.innerHTML = percentage + "%<br><span style='font-size:10px'>" + additionalText + "</span>";
            }
            generatePieChart(server.serverName+"cpu",cpu,'coral','CPU')
            generatePieChart(server.serverName+"mem",ram,'coral','Memory')

            triggerIcon.addEventListener('mouseover', function() {  //click
                popupDiv.style.display = 'block';
            });

            triggerIcon.addEventListener('mouseleave', function() {
                popupDiv.style.display = 'none';
            });

            triggerIcon.addEventListener('click', function() {
                const textToCopy = popupDiv.innerText; // or popupDiv.innerHTML to copy HTML content
                const tempTextarea = document.createElement('textarea');
                tempTextarea.value = textToCopy;
                document.body.appendChild(tempTextarea);
                tempTextarea.select();
                document.execCommand('copy');
                document.body.removeChild(tempTextarea);
            });                 
        } //if execCommand


        // if (server.isEmpty == 'yes') {
        // plan later
        // }


        
    }); // jsonData.sort((unitA, unitB) => unitB.unitId - unitA.unitId).forEach((server) => {
});