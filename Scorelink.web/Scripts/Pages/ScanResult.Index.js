﻿
var ViewModel = function () {
    var self = this;
    //Array
    self.ScanEdit = ko.observableArray();
    self.AccGroupList = ko.observableArray();
    self.FormulaList = ko.observableArray();
    self.Summary = ko.observableArray();

    self.Footnote_No = ko.observable();
    self.Divisions = ko.observable();
    self.Digitized_Account_Title = ko.observable();
    self.AccountTitleGroupId = ko.observable();
    self.Recovered = ko.observable();
    self.Standard_Title = ko.observable();
    self.Amount1 = ko.observable();
    self.Amount2 = ko.observable();
    self.Amount3 = ko.observable();
    self.Modified = ko.observable();
    self.CLCTCD = ko.observable();
    self.EntryAccGroupId = ko.observable();

    self.FormulaId = ko.observable();
    self.FormulaName = ko.observable();
    self.FormulaDesc = ko.observable();
    self.FormulaQuery = ko.observable();
    self.FormulaLanguage = ko.observable();
    self.StatementTypeId = ko.observable();
    self.FormulaResult = ko.observable();

    self.CreateBy = ko.observable();
    self.AccGroupId = ko.observable();
    self.SumAmount1 = ko.observable();
    self.SumAmount2 = ko.observable();
    self.SumAmount3 = ko.observable();

    //Load Account Title Group Dropdown List
    getAccountTitleGroupDD();
    //Load OCR Data
    LoadData();
    //Load Formula Data
    //LoadFormula();

    var sFormulaRst;

    var pickedup;
    var tr;
    var row_index;
    var footnote;
    var footnote2;
    var digitize_account;
    var lastSelected;
    var row_start;
    $(document).ready(function () {
        //set scroll bar
        $('.pane-hScroll').scroll(function () {
            $('.pane-vScroll').width($('.pane-hScroll').width() + $('.pane-hScroll').scrollLeft());
        });
        // get row number
        $('#tbResult2 tbody tr').each(function (row_num) {
            $(this).children("td:eq(0)").html(row_num + 1);
        });
        //set value row selected
        $("#tbResult2 tbody tr").on("click", function (event) { 
            tr = $(this).closest("tr").toggleClass("row_selected");
           
        });
        //set index column selected
        $('td').click(function () {
            row_index = $(this).parent().index();
            //var col_index = $(this).index();     
        });   
        // Insert Row
        $("#BtnInsert").click(function () {
            var row = $("#tbResult2 tbody tr:last-child").clone(true);
            $("td", row).eq(1).html("");
            //$("td", row).eq(2).html("");
            $("td", row).eq(3).html("");
            $("td", row).eq(6).html("");
            $('#tbResult2 > tbody > tr').eq(row_index).after(row);
            $("#BtnCheck").attr("disabled", true);
            $("#BtnMerge").attr("disabled", true);
            //$("#BtnExport").attr("disabled", true);
            //$("#BtnDelete").attr("disabled", true);
            //$("#Commit").attr("disabled", true);
            run_rownumber();
        });
        $("#BtnMerge").click(function () {
            //set value row selected
          
        
            var footnote = $('#tbResult2').find('tr.row_selected').eq(0).find('td:eq(1)').text();
            var footnote2 = $('#tbResult2').find('tr.row_selected').eq(1).find('td:eq(1)').text();
            if ((footnote2 != "") && (footnote != "")) {
                footnote2 = footnote2 + "," + footnote;
            }
            else
            {
                footnote2 = footnote2 + footnote;
            }

           
            var digitize_account2 = $('#tbResult2').find('tr.row_selected').find('td:eq(3)').text(); 
            var idx_1 = $('#tbResult2').find('tr.row_selected')[0].rowIndex;
            var idx_2 = $('#tbResult2').find('tr.row_selected')[1].rowIndex;
            if (idx_2 - idx_1 != 1) {
                alert("Cannot merge row please select row again!");
                $('#tbResult2').find('tr.row_selected').toggleClass("row_selected");
                return false;     
            }   
            
            var amount = $('#tbResult2').find('tr.row_selected').eq(0).find('td:eq(6)').text();
            var amount2 = $('#tbResult2').find('tr.row_selected').eq(1).find('td:eq(6)').text();
            
            if ((amount2 != "") && (amount != "")) {
                alert("Cannot merge row please check data");
                $('#tbResult2').find('tr.row_selected').toggleClass("row_selected");
                return false;
            }
            else {
                var amount2 = $('#tbResult2').find('tr.row_selected').find('td:eq(6)').text();
            }
            
            tr.remove();
            $('#tbResult2').find('tr.row_selected').find('td:eq(1)').text(footnote2);
            $('#tbResult2').find('tr.row_selected').find('td:eq(3)').text(digitize_account2);
            $('#tbResult2').find('tr.row_selected').find('td:eq(6)').text(amount2);

            $('#tbResult2').find('tr.row_selected').toggleClass("row_selected");
        
            run_rownumber();

        });
        $("#BtnDelete").click(function () {
            tr.remove(); 
            run_rownumber();
        });
        //Check --edit data
        $("#BtnCheck").click(function () {
            row_start = $("#tbResult2 tbody tr:last-child").clone(true);
            var filter = {
                docId: $("#hddocId").val(),
                pageType: $("#hdPageType").val()
            }
            $.ajax({
                url: "/ScanResult/AssignGrid",
                cash: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: ko.toJSON(filter),
                success: OnSuccessCheck,
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });
            //set enable button
            $("#BtnCheck").attr("disabled", true);
            $("#BtnMerge").attr("disabled", true);
            $("#BtnInsert").attr("disabled", false);
            $("#BtnDelete").attr("disabled", false);
            $("#BtnCommit").attr("disabled", false);
            $("#BtnExport").attr("disabled", false);
            $("#BtnCancel").attr("disabled", false);
            //var type_event = "insert";
            edit_value();
        });

        $("#BtnCancel").click(function () {
            /*var filter = {
                docId: $("#hddocId").val(),
                pageType: $("#hdPageType").val()
            }
            $("#tbResult2").find("td").removeClass("row_selected");
            $("#tbResult2").find("td").toggleClass("changeBackground");
            $.ajax({
                url: "/ScanResult/AssignGrid",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: ko.toJSON(filter),
                success: OnSuccessCancel,
                failure: function (response) {
                    alert(response.d);
                },
                error: function (response) {
                    alert(response.d);
                }
            });*/
            //$("#BtnCheck").removeattr("disabled");
            //var row = $("#tbResult1 thead tr:last-child").clone(true);
            //$("#tbResult2 tbody tr").remove();
            //$("#tbResult1 thead tr").remove();
            //LoadData();
            /*$("#BtnCheck").attr("disabled", false);
            $("#BtnMerge").attr("disabled", false);
            $("#BtnInsert").attr("disabled", true);
            $("#BtnDelete").attr("disabled", true);
            $("#BtnCommit").attr("disabled", true);
            $("#BtnExport").attr("disabled", true);*/
            $.redirect("/ScanResult/Index", {
                'docId': $("#hddocId").val(),
                'pageType': $("#hdPageType").val(),
                'pagetypeName': $("#hdPageTypeName").val()
            }, "POST");
        });

        $("#BtnBack").click(function () {
            $.redirect("/SelectPage/SelectPage", {
                'id': $("#hddocId").val()
            }, "POST");
        });
        $("#BtnCommit").click(function () {
            var table1 = $("#tbResult1");
            var table2 = $("#tbResult2");
            var filename = "Tmp" + "00" + $("#hdPageType").val() + ".csv";
            //var sheetname = $("#hdPageTypeName").val();
            var csv_data = exportTableToCSV(table1,table2, filename);
            var temp_data = {
                docId: $("#hddocId").val(),
                pageType: $("#hdPageType").val(),
                csv_file: csv_data,
                filenames: filename
            }
            //console.log(csv_file);
            $.ajax({
                url: "/ScanResult/Commit_file",
                cash: false,
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: ko.toJSON(temp_data),
                success: function () {
                    alert("Commit file already");
                    $.redirect("/SelectPage/SelectPage", {
                        'id': $("#hddocId").val()
                    }, "POST");
                }
            });
       });
        $("#BtnExport").click(function () {
            var table1 = $("#tbResult1");
            var table2 = $("#tbResult2");
            var filename = "Result";
            var sheetname = $("#hdPageTypeName").val();
            ExportHTMLTableToExcel(table1,table2, sheetname, filename);
        });

        $("#BtnFinCheck").click(function () {
            SummaryScore();
            LoadFormula();
            $.toaster('Finance Check Success..!!', 'Success', 'success');
        });
    });
    function exportTableToCSV(table1,table2, filename) {
        var tab_text = "";
        var final_text = "";
        filename = isNullOrUndefinedWithEmpty(filename) ? "Result_data" : filename;
        var index = table2.find("tbody tr").length;
        if (Number(index) > 0) {
            $.each(table1, function (index, item) {
                var element = $(item);
                var headertext = table1.closest
                    (":has(label.HeaderLabel)").find('label').text().trim();
                if (headertext == "") {
                    tab_text = "";
                }
                else {
                    tab_text = headertext;
                }
                // Create column header
                element.find("thead tr th").each(function () {
                    if ($(this).hasClass("text-center")) {
                        var txt = $(this).text();
                        if (txt.indexOf(',') == 0 || txt.indexOf('\"') == 0 || txt.indexOf('\n') == 0) {
                            txt = "\"" + txt.replace(/\"/g, "\"\"") + "\"";
                        }
                        tab_text += txt + ",";
                    }
                });
                tab_text += '\n';
                // Create body column
                table2.find("tbody tr").each(function () {
                    
                    $(this).find("td").each(function () {
                        
                        if ($(this).hasClass("text-center") || $(this).hasClass("text-left") || $(this).hasClass("text-right")) {
                           // tab_text += ",";
                            var txt = $(this).text();
                            if (txt.indexOf(',') >= 0 || txt.indexOf('\"') >= 0 || txt.indexOf('\n') >= 0) {
                                txt = "\"" + txt.replace(/\"/g, "\"\"") + "\"";
                            }
                            tab_text += txt + ",";
                        }
                        else if ($(this).hasClass("dropdown")) {
                            //tab_text += ",";
                            $(this).find("select").each(function () {
                                var txt = "";
                                if ($(this).prop("type") == 'select-one') {
                                    txt = $('option:selected', this).text();
                                    if (txt.indexOf(',') >= 0 || txt.indexOf('\"') >= 0 || txt.indexOf('\n') >= 0) {
                                        txt = "\"" + txt.replace(/\"/g, "\"\"") + "\"";
                                    }
                                } else {
                                    txt = $(this).val();
                                    if (txt.indexOf(',') >= 0 || txt.indexOf('\"') >= 0 || txt.indexOf('\n') >= 0) {
                                        txt = "\"" + txt.replace(/\"/g, "\"\"") + "\"";
                                    }
                                }
                                tab_text += txt + ",";
                            });
                        }
                        else {}
                    });
                    tab_text += '\n';
                     
                });
            });
             
        } // end if
        return tab_text;
    }
    function ExportHTMLTableToExcel(table1,table2,sheetName,filename) {
        var tab_text = ""
        var final_text = "";
        filename = isNullOrUndefinedWithEmpty(filename) ? "Result_data" : filename;
        var index = table2.find("tbody tr").length;
        //read data from tbody of table
        if (Number(index) > 0) {
            $.each(table1, function (index, item) {
                var element = $(item);
                var headertext = table1.closest
                    (":has(label.HeaderLabel)").find('label').text().trim();
                if (headertext == "") {
                    tab_text = "<table border='2px'><tr>";
                }
                else {
                    tab_text = "<table border='2px'><tr> " + headertext + "</tr><tr>";
                }
                // Create column header
                element.find("thead tr th").each(function () {
                    if (!$(this).hasClass("text"))
                        tab_text = tab_text + "<td bgcolor='#87AFC6'>" +
                            $(this)[0].innerHTML + "</td>";
                });
                //Close column header
                tab_text = tab_text + "</tr>";
                // Create body column
                table2.find(" tbody tr").each(function () {
                    tab_text = tab_text + "<tr>";
                    $(this).find("td").each(function () {
                        if ($(this).hasClass("text-center") || $(this).hasClass("text-left") || $(this).hasClass("text-right")) {
                            var value = $(this).text();                     
                            tab_text = tab_text + "<th>" + value + "</th>";                      
                        }
                        else {
                            $(this).find("select").each(function () {
                                var value = "";
                                if ($(this).prop("type") == 'select-one') {
                                    value = $('option:selected', this).text();
                                } else {
                                   value = $(this).val();
                                }
                                tab_text = tab_text + "<th>" + value + "</th>";
                            });
                        }
                    });
                    tab_text = tab_text + "</tr>";
                    if (index == 0) {
                        final_text = tab_text;
                    }
                    else {
                        final_text = final_text + tab_text;
                    }
                });
            });          
            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");
            if (msie > 0 || !!navigator.userAgent.match
                (/Trident.*rv\:11\./))      // If Internet Explorer
            {
                txtArea1 = window.open();
                txtArea1.document.open("txt/html", "replace");
                txtArea1.document.write(final_text);
                txtArea1.document.close();
                txtArea1.focus();
                sa = txtArea1.document.execCommand("SaveAs", true, filename + ".xlsx");
                return (sa);
            }
            else  //other browser not tested on IE 11
            {
                var ctx = { worksheet: sheetName || 'Worksheet', table: table1.innerHTML };
                var anchor = document.createElement('a');
                //var base64file = "base64," + $.base64.encode(final_text);
                anchor.setAttribute('href', 'data:application/vnd.ms-excel,' +  encodeURIComponent(final_text));
                //anchor.setAttribute('href', 'data:application/vnd.ms-excel,' + 'filename =' + $filename.excel, + base64file)
                  
                //-----------------------------------------------------------------
                anchor.setAttribute('download', sheetName);
                //anchor.style.display = 'none';
                document.body.appendChild(anchor);
                anchor.click();
                document.body.removeChild(anchor);
            }
        }
    }
    function isNullOrUndefinedWithEmpty(text) {
        if (text == undefined)
            return true;
        else if (text == null)
            return true;
        else if (text == null)
            return true;
        else
            false;
    }
    function OnSuccessCheck(response) {
        blockUI();
        var model = response;
        var post_data = [];
       //Hide comlum
        //$(".Grid td:nth-child(3),th:nth-child(3)").toggle(); //Division Hide
        $(".Grid td:nth-child(5),th:nth-child(5)").toggle(); //Recovered
        $(".Grid td:nth-child(6),th:nth-child(6)").toggle(); //Standard
        $(".Grid td:nth-child(7),th:nth-child(7)").toggle(); //Custom Title
        //$(".Grid td:nth-child(11),th:nth-child(11)").toggle(); //Modify
        //$(".Grid td:nth-child(12),th:nth-child(12)").toggle(); //CLCTCD

        
        //-----------------------------------------------------
        var row = $("#tbResult2 tbody tr:last-child").clone(true);
      
        $('#tbResult2 tbody tr').each(function (row_num) {
            $('#tbResult2 > tbody > tr').eq(row_num).find('td:eq(2)').html('<select name = "Combo" id = "Combo" class="form-control input-sm">\n\
                <option value="Low">Major0</option>\n\
                <option value="Normal">Major1</option>\n\
                <option value="High">Major2</option></select>');
            $('#tbResult2 > tbody > tr').eq(row_num).find('td:eq(4)').html('<select id="select_' + row_num + '" class="form-control input-sm"></select>');
            $('#tbResult2 > tbody > tr').eq(row_num).find('td:eq(6)').html('<select id="customDic_' + row_num + '" class="form-control input-sm"></select>');
            post_data.push($('#tbResult2 > tbody > tr').eq(row_num).find('td:eq(3)').text());
        });
  
        $.ajax({
            url: "/ResultDict/AssignGrid",
            cache: false,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            data: ko.toJSON({ pageType: $("#hdPageType").val(), docId: $("#hddocId").val(), account_title: post_data }),
            success: function (response) {
                var len = response.RecoverData.length;
                for (i = 0; i < len; i++) {
                    for (var j = 0; j < response.RecoverData[i].length; j++) {

                        $('#select_' + i).append(new Option(response.RecoverData[i][j], response.RecoverData[i][j]));
                       
                      
                    }
                    for (var j = 0; j < response.CustomData[i].length; j++) {

                        $('#customDic_' + i).append(new Option(response.CustomData[i][j], response.CustomData[i][j]));

                    }
                    $('#tbResult2 > tbody > tr').eq(i).find('td:eq(5)').text(response.stdValue[i]);
                   
                }
                unblockUI();
            }
        });       
        run_rownumber();
    };
    function OnSuccessCancel(response) {
        var model = response;
        //set column to hidden
        $(".Grid td:nth-child(3),th:nth-child(3)").hide();
        $(".Grid td:nth-child(5),th:nth-child(5)").hide();
        $(".Grid td:nth-child(9),th:nth-child(9)").hide();
        $(".Grid td:nth-child(3)").css("background-color", "#ffffff");
        var row = row_start;
        $("#tbResult2 tbody tr").remove();
        $.each(model, function () {
            var financials = this;
            $("td", row).eq(1).html(financials.Footnote_No);
            $("td", row).eq(2).html(financials.Divisions);
            $("td", row).eq(3).html(financials.Digitized_Account_Title);
            $("td", row).eq(4).html(financials.Recovered);
            $("td", row).eq(5).html(financials.Standard_Title);
            $("td", row).eq(6).html(financials.Amount);
            $("td", row).eq(7).html(financials.Modified);
            $("td", row).eq(8).html(financials.CLCTCD);
            $("#tbResult2").append(row);
            row = $("#tbResult2 tbody tr:last-child").clone(true);
        });
        $('#tbResult2 tbody tr').each(function (idx) {
            $(this).children("td:eq(0)").html(idx + 1);
        });
    };
    function LoadData() {
        var PatternNo = $("#hdPatternNo").val();

        //$(".Grid td:nth-child(2),th:nth-child(2)").hide(); //Footnote
        $(".Grid td:nth-child(7),th:nth-child(7)").hide(); //Custom Title
        if (PatternNo == "1") {
          $(".Grid td:nth-child(9),th:nth-child(9)").hide();//Amount2
          $(".Grid td:nth-child(10),th:nth-child(10)").hide();//Amount3
        }
        else if (PatternNo == "2") {
          $(".Grid td:nth-child(10),th:nth-child(10)").hide();//Amount3    
        }
        //$(".Grid td:nth-child(11),th:nth-child(11)").hide();//Modify
        //$(".Grid td:nth-child(12),th:nth-child(12)").hide();//CLCTCD      
        var filter = {
            docId: $("#hddocId").val(),
            pageType: $("#hdPageType").val()
        }
        //set disable button
        $("#BtnInsert").attr("disabled", true);
        $("#BtnDelete").attr("disabled", true);
        $("#BtnCommit").attr("disabled", true);
        $("#BtnCancel").attr("disabled", true);
        $.ajax({
            url: '/ScanResult/AssignGrid',
            cache: false,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: ko.toJSON(filter),
            success: function (data) {
                self.ScanEdit([]);
                ko.utils.arrayForEach(data, function (data) {
                    self.ScanEdit.push(
                        new ScanEditModel(
                            data.Footnote_No,
                            data.Divisions,
                            data.Digitized_Account_Title,
                            data.AccountTitleGroupId,
                            data.Recovered,
                            data.Standard_Title,
                            data.Amount1,
                            data.Amount2,
                            data.Amount3,
                            data.Modified,
                            data.CLCTCD,
                            self.AccGroupList()
                        )
                    );
                });
                //alert(self.ScanEdit().length);
                SummaryScore();
                LoadFormula();
            }
        })
    }
    function edit_value() {
        $("td").dblclick(function () {

            //var OriginalContent = $(this).text();
            var OriginalContent = $(this).text().replace(/\,/g, '');
            var col_index = $(this).index();
            if (col_index == 7) {
                $(this).addClass("cellEditing");
                $(this).html("<input type='text' style='text-align: right' value='" + OriginalContent + "' />");
                $(this).children().first().focus();
                $(this).children().first().keypress(function (e) {
                    if (e.which == 13) {
                         //var newContent = $(this).val();
                        var newContent = $(this).val().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
                        $(this).parent().text(newContent);
                        $(this).parent().removeClass("cellEditing");
                    }
                });
                $(this).children().first().blur(function () {
                    $(this).parent().text(OriginalContent);
                    $(this).parent().removeClass("cellEditing");
                });
            }
        });
    };
    function run_rownumber() {
        $('#tbResult2 tbody tr').each(function (row_num) {
            $(this).children("td:eq(0)").html(row_num + 1);
        });
    }
    function getAccountTitleGroupDD() {
        var filter = {
            sLanguage: $("#hdLanguage").val()
        }
        $.ajax({
            url: '/ScanResult/GetAccountTitleGroupDD',
            cache: false,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: ko.toJSON(filter),
            success: function (data) {
                self.AccGroupList([]);
                self.AccGroupList(data);
            }
        });
    }
    function ScanEditModel(Footnote_No, Divisions, Digitized_Account_Title, AccountTitleGroupId, Recovered, Standard_Title, Amount1, Amount2, Amount3, Modified, CLCTCD, AccGroupList) {
        var self = this;
        self.AccGroupListDD = ko.observableArray(AccGroupList);
        self.Footnote_No = ko.observable(Footnote_No);
        self.Divisions = ko.observable(Divisions);
        self.Digitized_Account_Title = ko.observable(Digitized_Account_Title);
        self.EntryAccGroupId = ko.observable(AccountTitleGroupId);
        self.Recovered = ko.observable(Recovered);
        self.Standard_Title = ko.observable(Standard_Title);
        self.Amount1 = ko.observable(Amount1);
        self.Amount2 = ko.observable(Amount2);
        self.Amount3 = ko.observable(Amount3);
        self.Modified = ko.observable(Modified);
        self.CLCTCD = ko.observable(CLCTCD);
    }
    function LoadFormula() {
        //$('#tbFormula').DataTable().clear();
        //$('#tbFormula').DataTable().destroy();
        var arg = {
            FormulaLanguage: $("#hdLanguage").val(),
            StatementTypeId: $("#hdPageType").val()
        }

        var filter = {
            'userId': $("#hdUserId").val(),
            'item': arg
        }

        $.ajax({
            url: '/ScanResult/GetFormulaList',
            cache: false,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: ko.toJSON(filter),
            success: function (data) {
                self.FormulaList([]);
                ko.utils.arrayForEach(data, function (data) {
                    self.FormulaList.push(
                        new FormulaModel(
                            data.FormulaId,
                            data.FormulaName,
                            data.FormulaDesc,
                            data.FormulaQuery,
                            data.FormulaResult,
                            data.FormulaLanguage,
                            data.StatementTypeId
                        )
                    );
                });
            },
            error: function (err) {
                $.toaster(err.statusText, 'Error', 'danger');
            }
        });
    }
    function FormulaModel(FormulaId, FormulaName, FormulaDesc, FormulaQuery, FormulaResult, FormulaLanguage, StatementTypeId) {
        var self = this;
        self.FormulaId = ko.observable(FormulaId);
        self.FormulaName = ko.observable(FormulaName);
        self.FormulaDesc = ko.observable(FormulaDesc);
        self.FormulaQuery = ko.observable(FormulaQuery);
        self.FormulaResult = ko.observable(FormulaResult);
        self.FormulaLanguage = ko.observable(FormulaLanguage);
        self.StatementTypeId = ko.observable(StatementTypeId);
    }
    function getFormulaResult(sQuery) {
        var filter = {
            'userId': $("#hdUserId").val(),
            'sQuery': sQuery
        }

        $.ajax({
            url: '/ScanResult/GetFormulaResult',
            cache: false,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: ko.toJSON(filter),
            success: function (data) {
                sFormulaRst = data;
                return data;
            },
            error: function (err) {
                return '';
                $.toaster(err.statusText, 'Error', 'danger');
            }
        });
    }
    function SummaryScore() {
        //alert(self.ScanEdit().length);
        self.Summary = ko.observableArray();

        ko.utils.arrayForEach(self.ScanEdit(), function(data){
            self.Summary.push(
                new SummaryScoreModel(
                    $("#hdUserId").val(),
                    data.EntryAccGroupId,
                    data.Amount1(),
                    data.Amount2(),
                    data.Amount3()
                )
            )
        });

        var filter = {
            item: self.Summary
        }

        $.ajax({
            url: '/ScanResult/SummaryScore',
            cache: false,
            type: 'POST',
            contentType: 'application/json; charset=utf-8',
            data: ko.toJSON(filter),
            success: function (data) {
                
            },
        });
    }
    function SummaryScoreModel(CreateBy, AccGroupId, SumAmount1, SumAmount2, SumAmount3) {
        var self = this;
        self.CreateBy = ko.observable(CreateBy);
        self.AccGroupId = ko.observable(AccGroupId);
        self.SumAmount1 = ko.observable(SumAmount1);
        self.SumAmount2 = ko.observable(SumAmount2);
        self.SumAmount3 = ko.observable(SumAmount3);
    }

}
var viewModel = new ViewModel();
ko.applyBindings(viewModel);
