//Naviagation
function openNav() {
  document.getElementById("mySidepanel").style.width = "250px";
}

function closeNav() {
  document.getElementById("mySidepanel").style.width = "0";
}


function noRecord(textMessage) {
  document.getElementById("Computer").innerHTML = textMessage;
  document.getElementById("OperatingSystem").innerHTML = textMessage;
  document.getElementById("Memory").innerHTML = textMessage;
  document.getElementById("Processor").innerHTML = textMessage;
  document.getElementById("MotherBoard").innerHTML = textMessage;
  document.getElementById("HardDisks").innerHTML = textMessage;
  document.getElementById("NetworkCard").innerHTML = textMessage;
  document.getElementById("VideoCards").innerHTML = textMessage;
  document.getElementById("Monitors").innerHTML = textMessage;
}

function GetMemoryCapacity( jsonItem ) {
  var total = 0;
  var partNumber = '';
  for (i =0; i < jsonItem.length; i++) {
    total += jsonItem[i].Capacity;
    if (i === 0) {
      partNumber += jsonItem[i].PartNumber;
    }
    else {
      partNumber += ', ' + jsonItem[i].PartNumber;
    }  
    
  }
  return (total / (1024 * 1024 *1024 )).toFixed(2) +  ' GB (' + partNumber + ')';
}

function GetHardDiskCapacity( jsonItem ) {
  var total = 0;
  var partNumber = '';
  for (i =0; i < jsonItem.length; i++) {
    total += jsonItem[i].Size;
    if (i === 0) {
      partNumber += jsonItem[i].Model;
    }
    else {
      partNumber += ', ' + jsonItem[i].Model;
    }  
    
  }
  return (total / (1024 * 1024 *1024 )).toFixed(2) +  ' GB (' + partNumber + ')';
}

function GetNet_VideoCards( jsonItem ) {
  var total = '';
  for (i =0; i < jsonItem.length; i++) {
    if (i === 0) {
      total += jsonItem[i].Name;
    }
    else
    {
      total += ', ' + jsonItem[i].Name;
    }
  }
  return jsonItem.length + ' (' + total + ')';
}

function GetMonitors( jsonItem ) {
  var total = '';
  for (i =0; i < jsonItem.length; i++) {
    if (i === 0) {
      total += jsonItem[i].ManufacturerName;
    }
    else
    {
      total += ', ' + jsonItem[i].ManufacturerName;
    }
  }
  return jsonItem.length + ' (' + total + ')';
}

/*
function createTable( jsonItem ) {
  var table = `<div class="tooltip-content"> <table>`;
  
  for (i =0; i < jsonItem.length; i++) {
    var keys = Object.keys(jsonItem[i]);
   
    table += "<tr>";
    for (j =0; j < keys.length; j++) {
      table += "<th>" +  keys[j] + " </th>";
      table += "<td>" +  jsonItem[i][keys[j]] + " </td>";
    }
    table += "</tr>";
  }

  table += "</table> </div>";
  return keys
  //return table;
}
*/

function createTable( jsonItem ) {
  var table = `<div class="tooltip-content"> <table>`;
  if (jsonItem.length === undefined) {
    var keys = Object.keys(jsonItem)
    var k = 0
    for ( var data in jsonItem ) {
      table += "<tr>";
      table += "<th>" +  keys[k] + " </th>";
      table += "<td>" +  jsonItem[data] + " </td>"; //"<td>" +  data[keys[k]] + " </td>";
      table += "</tr>"; 
      k++
    }
  }
  else 
  {
    for (i = 0; i < jsonItem.length; i++) {
      var keys = Object.keys(jsonItem[i]);
      if (i !== 0)
      {
        table += "<tr><td>------------------------</td></tr>"
      }
      for (j =0; j < keys.length; j++) {
        table += "<tr>";
        table += "<th>" +  keys[j] + " </th>";
        table += "<td>" +  jsonItem[i][keys[j]] + " </td>";
        table += "</tr>";
      }
    }
  }
  table += "</table> </div>";
  return table
  //return table;
}

function GenerateData() {
  var textboxValue = document.getElementById("myText").value;
  var foundData = data.find(function (item){
    return item.ComputerName.toLowerCase() === textboxValue.toLowerCase();
  });
  if (typeof foundData === 'undefined') {
    document.getElementById("myText").value = '';
    document.getElementById("FirstPhaseResult").innerHTML = 'No data found for server <strong style="color:Red;">' + textboxValue.toLowerCase() + ' </strong>Try with different hostname';
    noRecord('No Record Found');
  } 
  else if (typeof foundData === 'null'){
    document.getElementById("myText").value = '';
    document.getElementById("FirstPhaseResult").innerHTML = 'No data found for server <strong style="color: Red;">' + textboxValue.toLowerCase() + ' </strong>Try with different hostname';
    noRecord('No Record Found');
  }
  else
  {
    noRecord('Fetching Reports... Please wait >>> Error fetching data');
    document.getElementById("FirstPhaseResult").innerHTML = 'Found Server: <strong style="color: DarkGreen;">' + foundData.ComputerName + '</strong>';
  
  //not added exampletest anywhere safe to remove
  var exampletest = `<div class="tooltip-content"> 
    <table>
      <tr>
        <th>Company</th>
        <th>Contact</th>
        <th>Country</th>
        <th>Country</th>
        <th>Country</th>
        <th>Country</th>
        <th>Country</th>
      </tr>
      <tr>
        <td>Alfreds Futterkiste</td>
        <td>Maria Anders</td>
        <td>Germany</td>
        <td>Germany</td>
        <td>Germany</td>
        <td>Germany</td>
        <td>Germany</td>
      </tr>
    </table>
  </div>`;
    
    document.getElementById("Computer").innerHTML = foundData.ComputerName + ' (' + foundData.computerSystem.Manufacturer + ' ' + foundData.computerSystem.Model + ')' + createTable(foundData.computerSystem); //exampletest;
    document.getElementById("OperatingSystem").innerHTML = foundData.operatingSystem.Caption + ' ' + '(' + foundData.operatingSystem.OSArchitecture + ')' + createTable(foundData.operatingSystem);
    document.getElementById("MotherBoard").innerHTML = foundData.baseBoard.Manufacturer + ' (' + foundData.baseBoard.Product + ')' + createTable(foundData.baseBoard);
    document.getElementById("Processor").innerHTML = foundData.processor.Name + createTable(foundData.processor);
    document.getElementById("Memory").innerHTML = GetMemoryCapacity(foundData.physicalMemory) + createTable(foundData.physicalMemory);
    document.getElementById("HardDisks").innerHTML = GetHardDiskCapacity(foundData.diskDrive) + createTable(foundData.diskDrive);
    document.getElementById("NetworkCard").innerHTML = GetNet_VideoCards(foundData.networkAdapter) + createTable(foundData.networkAdapter);
    document.getElementById("VideoCards").innerHTML = GetNet_VideoCards(foundData.videoController) + createTable(foundData.videoController);
    document.getElementById("Monitors").innerHTML = GetMonitors(foundData.monitor) + createTable(foundData.monitor);
  }
}
