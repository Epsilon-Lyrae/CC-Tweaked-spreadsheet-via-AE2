function doPost(e) {
  const data = JSON.parse(e.postData.contents);

  const sheetName = data.sheet

  const sheet = SpreadsheetApp
    .getActiveSpreadsheet()
    .getSheetByName(sheetName);

  if (data.writes && Array.isArray(data.writes)) {
    for (const w of data.writes) {
      sheet.getRange(w.cell).setValue(w.value);
    }
  }

  if (data.deleteRows) {
    data.deleteRows.sort((a,b) => b - a);
    for (const row of data.deleteRows) {
      sheet.deleteRow(row);
    }
  }

  if (data.compact) {
    const dataRange = sheet.getDataRange().getValues();

    const filtered = dataRange.filter(row =>
      row.some(cell => cell !== "" && cell !== null)
    );

    sheet.clearContents();

    if (filtered.length > 0) {
      sheet.getRange(1,1,filtered.length,filtered[0].length)
           .setValues(filtered);
    }
  }

  return ContentService.createTextOutput("OK");
}
