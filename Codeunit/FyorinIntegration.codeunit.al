/// <summary>
/// Codeunit Fyorin Integration  (ID 92955).
/// </summary>
codeunit 92955 "Fyorin Integration"
{
    trigger OnRun()
    var
        ApiSetup: Record "Fyorin Setup";
    begin
        ApiSetup.Get();
        //LoginAccessorOwner(ApiSetup.accessor_owner_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_email, ApiSetup.accessor_api_key_password, ApiSetup.URL, ApiSetup."Api Token");
        HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
    end;

    /// <summary>
    /// HttpRequest.
    /// </summary>
    /// <param name="APIToken">VAR Text.</param>
    /// <param name="Email">Text.</param>
    /// <param name="Password">Text.</param>
    /// <param name="PasswordToken">Text.</param>
    /// <param name="ApiURL">text.</param>
    /// <returns>Return variable Statuscode of type integer.</returns>
    procedure HttpRequest(var APIToken: Text; Email: Text; Password: Text; PasswordToken: Text; ApiURL: text) token: Text
    var

        Client: HttpClient;
        Content: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        Jobject: JsonObject;
        Jtoken: JsonToken;
        Jpw: JsonObject;
        Jtext: Text;
        RootAuth: JsonObject;
        //RootArray: JsonArray;
        RootToken: JsonToken;
        tokentext: Text;
        Root: JsonToken;
        Rootobject2: JsonObject;

    begin

        Jobject.Add('email', Email);
        Jpw.Add('password', PasswordToken);
        Jobject.Add('password', Jpw);
        Jobject.Add('isApi', true);
        Jobject.WriteTo(Jtext);
        Content.WriteFrom(Jtext);
        Content.GetHeaders(HttpHeader);
        HttpHeader.Clear();

        HttpHeader.Add('Content-Type', 'application/json');

        Request.Content := Content;
        RequestString := ApiURL + '/api/auth/login';
        Request.SetRequestUri(RequestString);
        Request.Method := 'POST';

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ContentTXT) then begin
                    RootAuth.ReadFrom(ContentTXT);
                    if RootAuth.Get('auth', Root) then
                        Rootobject2 := Root.AsObject();
                    if Rootobject2.Get('token', RootToken) then
                        tokentext := RootToken.AsValue().AsText();
                    exit(tokentext);
                    //Message('%1', tokentext);
                    //exit(Response.HttpStatusCode);
                end
            end else
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT);
        end;
    end;
    /// <summary>
    /// CreateSubAccount.
    /// </summary>
    /// <param name="MainID">VAR Text.</param>
    /// <param name="Name">text.</param>
    /// <param name="currCode">code[20].</param>
    procedure CreateSubAccount(var MainID: Text; Name: text; currCode: code[20])
    var
        BankAccount: Record "Bank Account";
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        Jobject: JsonObject;
        Jtext: Text;
        // MainID: text;
        TokenText: text;

    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        Jobject.Add('mainAccountId', MainID);
        Jobject.Add('name', Name);
        Jobject.Add('currency', currCode);
        //until BankAccount.Next() = 0;
        Jobject.WriteTo(Jtext);
        httpContents.WriteFrom(Jtext);
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/sub_accounts/_/create';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');
        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Message('Account Created Successfully');

                //  Message('%1 : %2', Response.HttpStatusCode, Jtext);


            end else
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
        end else
            Error('Cannot Send Request!');
    end;

    /// <summary>
    /// CreateContacts.
    /// </summary>
    procedure GetContacts()
    var
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        MainId: text;
    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        MainId := GetMainID();
        httpContents.WriteFrom('{}');
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/contacts/get';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ResponseText) then begin
                    Message('%1', ResponseText);
                end;
            end else begin
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;
    end;

    /// <summary>
    /// GetRequiredDetails.
    /// </summary>
    procedure GetRequiredDetails()
    var
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        Jtext: text;
        Jobject: JsonObject;
    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        Jobject.Add('bankCurrency', 'EUR');
        Jobject.Add('bankCountry', 'MT');
        Jobject.Add('beneficiaryType', 'COMPANY');
        Jobject.WriteTo(Jtext);

        httpContents.WriteFrom(Jtext);
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/contacts/required_details';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ResponseText) then begin
                    Message('%1', ResponseText);
                end;
            end else begin
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;
    end;
    /// <summary>
    /// CreatContact_Vendor.
    /// </summary>
    /// <param name="Var VendorNo">Code[20].</param>
    procedure CreatContact_Vendor(Var VendorNo: Code[20])
    var
        VendorREC: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        Jtext: text;
        Jobject: JsonObject;
        detailObject: JsonObject;
        extraObject: JsonObject;
        BankName: text;
        bankaddress: text;
        iban: text;
        SwiftCode: text;
        BankacctNo: text;
        bankcurrency: text;
        bankcountry: text;
        SortCode: Text;
        ResObject: JsonObject;
        ResToken: JsonToken;


    begin
        ClearAll();
        VendorREC.Get(VendorNo);
        VendorBankAccount.SetRange("Vendor No.", VendorNo);
        if VendorBankAccount.FindFirst() then begin
            BankacctNo := VendorBankAccount."Bank Account No.";
            bankaddress := VendorBankAccount.Address;
            BankName := VendorBankAccount.Name;
            iban := VendorBankAccount.IBAN;
            bankcountry := VendorBankAccount."Country/Region Code";
            bankcurrency := VendorBankAccount."Currency Code";
            SwiftCode := VendorBankAccount."SWIFT Code";
            SortCode := VendorBankAccount."Bank Clearing Code";

        end;

        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        Jobject.Add('beneficiaryType', 'COMPANY');
        Jobject.Add('reference', VendorNo);
        detailObject.Add('bankHolderName', VendorREC.Name);
        detailObject.Add('bankCountry', bankcountry);
        detailObject.Add('bankCurrency', bankcurrency);
        detailObject.Add('beneficiaryCountry', bankcountry);

        extraObject.Add('companyName', VendorREC.Name);
        //  extraObject.Add('lastName', '');
        extraObject.Add('address', VendorREC.Address);
        extraObject.Add('city', vendorRec.city);
        extraObject.Add('iban', iban);
        extraObject.Add('bicSwift', SwiftCode);
        // extraObject.Add('sortCode', SortCode);
        //  extraObject.Add('accountNumber', BankacctNo);
        //  extraObject.Add('bankName', BankName);
        //  extraObject.Add('bankAddress', bankaddress);
        detailObject.Add('extra', extraObject);
        Jobject.Add('details', detailObject);
        Jobject.WriteTo(Jtext);

        httpContents.WriteFrom(Jtext);
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/contacts/_/create';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Message('Vendor Created Successfully');
            end else begin
                if Response.Content().ReadAs(ContentTXT) then begin
                    if ResObject.ReadFrom(ContentTXT) then
                        if ResObject.Get('message', ResToken) then
                            Message('Error: %1', ResToken.AsValue().AsText());
                end
                // error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;


    end;

    /// <summary>
    /// ActivateCurrency.
    /// </summary>
    /// <param name="currCode">VAR Code[20].</param>
    /// <param name="subAcct">Code[20].</param>
    procedure ActivateCurrency(var currCode: Code[20]; subAcct: Code[20])
    var
        ApiSetup: Record "Fyorin Setup";
        SubacctRec: Record "Sub Account on Fyorin";
        banId: text;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Client: HttpClient;
        RequestString: text;
        httpHeader: HttpHeaders;
        httpContents: HttpContent;
        TokenText: Text;
        ContentTXT: text;

    begin

        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        // SubacctRec.Reset();
        // SubacctRec.SetRange(Account, subAcct);
        // if SubacctRec.FindFirst() then
        //     banId := SubacctRec."Ban Id";
        //httpContents.WriteFrom('{}');
        //httpContents.GetHeaders(HttpHeader);
        //httpHeader.Clear();
        //httpHeader.Add('Content-Type', 'application/json');
        //Request.GetHeaders(httpHeader);
        // HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + 'sub_accounts/' + subAcct + '/' + currCode + '/activate';   //{108594738475630856}
        Request.SetRequestUri(RequestString);
        //Request.Content := httpContents;
        Request.Method('POST');
        Client.DefaultRequestHeaders().Add('Authorization', 'Bearer ' + TokenText);
        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Message('Currency activated Successfully');

            end else
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
        end else
            Error('Cannot Send Request!');
    end;
    /// <summary>
    /// GetSubaccount.
    /// </summary>
    procedure GetSubaccount()
    var
        ApiSetup: Record "Fyorin Setup";
        SubAccountRec: Record "Sub Account on Fyorin";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        SubAcctJobject: JsonObject;
        SubAcctToken: JsonToken;
        SubAccTokenJobject: JsonObject;
        SubArray: JsonArray;
        SubTokenInArray: JsonToken;
        AcctToken: JsonToken;
        SAccObject: JsonObject;
        AccToken: JsonToken;
        IdToken: JsonToken;
        SAcctToken: JsonToken;
        AccObject: JsonObject;
        AccountID: Text;
        mainToken: JsonToken;
        MainId: text;
        MainObject: JsonObject;
        IdToken2: JsonToken;
        CurrBalToken: JsonToken;
        CurrBalObject: JsonObject;
        currToken: JsonToken;
        CurrObject: JsonObject;
        BalToken: JsonToken;
        AvailBal: decimal;
        pendingBal: Decimal;
        PendingToken: JsonToken;
        creditLimit: Decimal;
        Credittoken: JsonToken;
        unreservedLimit: decimal;
        unreservedToken: JsonToken;
        reservedToken: JsonToken;
        reservedBal: Decimal;
        nameToken: JsonToken;
        nameText: text;
        referenceToken: JsonToken;
        referenceText: text;
        activetoken: JsonToken;
        active: Boolean;
        DefaultBanToken: JsonToken;
        DefaultBanObject: JsonObject;
        banIdToken: JsonToken;
        BanidObject: JsonObject;
        BanidValueToken: JsonToken;
        BanidValue: text;
        FundingToken: JsonToken;
        FundingObject: JsonObject;
        currFtoken: JsonToken;
        GBPunreservedLimit: Decimal;
        GBPcreditLimit: Decimal;
        GBPpendingBal: decimal;
        GBPreservedBal: Decimal;
        GBPAvailBal: decimal;
        GBPToken: JsonToken;
        GBPObject: JsonObject;
        StatusToken: JsonToken;
        StatusText: text;
        FundingDetToken: JsonToken;
        FundingObject1: JsonObject;
        SwiftToken: JsonToken;
        SwiftObject: JsonObject;
        CountryToken: JsonToken;
        CountryText: text;
        CurrenToken: JsonToken;
        CurrenText: text;
        bankholderName: JsonToken;
        BankHolderNameTxt: text;


    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);

        httpContents.WriteFrom('{}');
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/sub_accounts/get';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ResponseText) then begin
                    if SubAcctJobject.ReadFrom(ResponseText) then begin
                        SubAcctJobject.SelectToken('subAccount', SubAcctToken);
                        SubArray := SubAcctToken.AsArray();
                        foreach SubTokenInArray in SubArray do begin
                            if SubTokenInArray.IsObject() then
                                SubAccTokenJobject := SubTokenInArray.AsObject();
                            if SubAccTokenJobject.Get('subAccount', SAcctToken) then begin
                                SAccObject := SAcctToken.AsObject();

                                if SAccObject.Get('account', AccToken) then
                                    AccObject := AccToken.AsObject();
                                if AccObject.Get('id', IdToken) then begin
                                    AccountID := IdToken.AsValue().AsText();

                                    if AccObject.Get('main', mainToken) then begin
                                        MainObject := mainToken.AsObject();
                                        if MainObject.Get('id', IdToken2) then
                                            MainId := IdToken2.AsValue().AsText();
                                        if AccObject.Get('name', nameToken) then
                                            nameText := nameToken.AsValue().AsText();
                                        if AccObject.Get('reference', referenceToken) then
                                            referenceText := referenceToken.AsValue().AsText();
                                        if AccObject.Get('active', activeToken) then
                                            active := activetoken.AsValue().AsBoolean();
                                    end;
                                    if AccObject.Get('currencyBalances', CurrBalToken) then
                                        CurrBalObject := CurrBalToken.AsObject();
                                    IF CurrBalObject.Get('GBP', currToken) then begin
                                        CurrObject := currToken.AsObject();
                                        if CurrObject.Get('available', BalToken) then
                                            GBPAvailBal := BalToken.AsValue().AsDecimal();
                                        if CurrObject.Get('reserved', reservedToken) then
                                            GBPreservedBal := reservedToken.AsValue().AsDecimal();
                                        if CurrObject.Get('pending', PendingToken) then
                                            GBPpendingBal := PendingToken.AsValue().AsDecimal();
                                        if CurrObject.Get('creditLimit', Credittoken) then
                                            GBPcreditLimit := Credittoken.AsValue().AsDecimal();
                                        if CurrObject.Get('unreservedLimit', unreservedToken) then
                                            GBPunreservedLimit := unreservedToken.AsValue().AsDecimal();
                                    end;
                                    IF CurrBalObject.Get('EUR', currToken) then begin
                                        CurrObject := currToken.AsObject();
                                        if CurrObject.Get('available', BalToken) then
                                            AvailBal := BalToken.AsValue().AsDecimal();
                                        if CurrObject.Get('reserved', reservedToken) then
                                            reservedBal := reservedToken.AsValue().AsDecimal();
                                        if CurrObject.Get('pending', PendingToken) then
                                            pendingBal := PendingToken.AsValue().AsDecimal();
                                        if CurrObject.Get('creditLimit', Credittoken) then
                                            creditLimit := Credittoken.AsValue().AsDecimal();
                                        if CurrObject.Get('unreservedLimit', unreservedToken) then
                                            unreservedLimit := unreservedToken.AsValue().AsDecimal();
                                    end;
                                end;
                                if SAccObject.Get('defaultBan', DefaultBanToken) then begin
                                    DefaultBanObject := DefaultBanToken.AsObject();
                                    if DefaultBanObject.Get('ban', banIdToken) then begin
                                        BanidObject := banIdToken.AsObject();
                                        if BanidObject.Get('id', BanidValueToken) then
                                            BanidValue := BanidValueToken.AsValue().AsText();
                                        if BanidObject.Get('fundingDetails', fundingToken) then begin
                                            fundingobject := FundingToken.AsObject();
                                            if fundingObject.Get('GBP', GBPtoken) then
                                                GBPObject := GBPToken.AsObject();
                                            if GBPObject.Get('status', StatusToken) then
                                                statustext := StatusToken.AsValue().AsText();
                                            if GBPObject.Get('fundingDetail', FundingDetToken) then
                                                FundingObject1 := FundingDetToken.AsObject();
                                            if FundingObject1.Get('SWIFT', SwiftToken) then begin
                                                SwiftObject := SwiftToken.AsObject();
                                                if SwiftObject.Get('bankHolderName', bankholderName) then
                                                    BankHolderNameTxt := bankholderName.AsValue().AsText();

                                                if SwiftObject.Get('country', CountryToken) then
                                                    CountryText := CountryToken.AsValue().AsText();
                                                if SwiftObject.Get('currency', CurrenToken) then
                                                    CurrenText := CurrenToken.AsValue().AsText();



                                            end;


                                        end;
                                    end
                                end;
                            end;
                            SubAccountRec.Reset();
                            SubAccountRec.SetRange(Account, AccountID);
                            if SubAccountRec.FindFirst() then begin
                                SubAccountRec."Ban Id" := BanidValue;
                                SubAccountRec.Name := nameText;
                                //SubAccountRec."Bank Holder Name" :=
                                SubAccountRec.Reference := referenceText;
                                SubAccountRec.Active := active;
                                SubAccountRec."Main Id" := MainId;
                                SubAccountRec."Eur Available Balance" := AvailBal;
                                SubAccountRec."Eur Credit Limit" := creditLimit;
                                SubAccountRec."Eur Pending" := pendingBal;
                                SubAccountRec."Eur Unreserved Limit" := unreservedLimit;
                                SubAccountRec."Eur Reserved" := reservedBal;
                                SubAccountRec."GBP Credit Limit" := GBPcreditLimit;
                                SubAccountRec."GBP Reserved" := GBPreservedBal;
                                SubAccountRec."GBP Pending" := GBPpendingBal;
                                SubAccountRec."GBP Unreserved Limit" := GBPunreservedLimit;
                                SubAccountRec."GBP Available Balance" := GBPAvailBal;
                                SubAccountRec.Country := countrytext;
                                SubAccountRec."Bank Holder Name" := BankHolderNameTxt;
                                SubAccountRec."Currency Code" := CurrenText;
                                SubAccountRec.Status := StatusText;
                                SubAccountRec.Modify();

                            end else begin
                                SubAccountRec.SetRange(Account, AccountID);
                                if not SubAccountRec.FindFirst() then begin
                                    SubAccountRec.Init();
                                    SubAccountRec.Account := AccountID;
                                    SubAccountRec."Account Id" := AccountID;
                                    SubAccountRec."Ban Id" := BanidValue;
                                    SubAccountRec.Name := nameText;
                                    //SubAccountRec."Bank Holder Name" :=
                                    SubAccountRec.Reference := referenceText;
                                    SubAccountRec.Active := active;
                                    SubAccountRec."Eur Available Balance" := AvailBal;
                                    SubAccountRec."Eur Credit Limit" := creditLimit;
                                    SubAccountRec."Main Id" := MainId;
                                    SubAccountRec."Eur Pending" := pendingBal;
                                    SubAccountRec."Eur Unreserved Limit" := unreservedLimit;
                                    SubAccountRec."Eur Reserved" := reservedBal;
                                    SubAccountRec."GBP Credit Limit" := GBPcreditLimit;
                                    SubAccountRec."GBP Reserved" := GBPreservedBal;
                                    SubAccountRec."GBP Pending" := GBPpendingBal;
                                    SubAccountRec."GBP Unreserved Limit" := GBPunreservedLimit;
                                    SubAccountRec."GBP Available Balance" := GBPAvailBal;
                                    SubAccountRec.Country := countrytext;
                                    SubAccountRec."Bank Holder Name" := BankHolderNameTxt;
                                    SubAccountRec."Currency Code" := CurrenText;
                                    SubAccountRec.Status := StatusText;
                                    SubAccountRec.Insert();
                                end;
                            end;

                        end;

                    end else
                        Error('Invalid Json File');
                    // Message('%1:: %2', ResponseText, TokenText);

                end;
            end else begin
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;
    end;



    /// <summary>
    /// GetMainID.
    /// </summary>
    /// <returns>Return variable Idtoken of type Integer.</returns>
    procedure GetMainID() IdtokenValue: text //var ApiEndPoint: Text
    var
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        SubAcctJobject: JsonObject;
        SubAcctToken: JsonToken;
        SubAccTokenJobject: JsonObject;
        SubArray: JsonArray;
        SubTokenInArray: JsonToken;
        AcctToken: JsonToken;
        SAccObject: JsonObject;
        AccToken: JsonToken;
        IdToken: JsonToken;
        SAcctToken: JsonToken;
        AccObject: JsonObject;



    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);

        httpContents.WriteFrom('{}');
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/sub_accounts/get';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ResponseText) then begin
                    if SubAcctJobject.ReadFrom(ResponseText) then begin
                        SubAcctJobject.SelectToken('subAccount', SubAcctToken);
                        SubArray := SubAcctToken.AsArray();
                        foreach SubTokenInArray in SubArray do begin
                            if SubTokenInArray.IsObject() then
                                SubAccTokenJobject := SubTokenInArray.AsObject();
                            if SubAccTokenJobject.Get('subAccount', SAcctToken) then
                                SAccObject := SAcctToken.AsObject();

                            if SAccObject.Get('account', AccToken) then
                                AccObject := AccToken.AsObject();
                            if AccObject.Get('id', IdToken) then
                                exit(IdToken.AsValue().AsText());
                            //Message('%1', ResponseText);
                        end;
                        // Message('%1', ResponseText);


                    end else
                        Error('Invalid Json File');
                    // Message('%1:: %2', ResponseText, TokenText);

                end;
            end else begin
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;
    end;

    /// <summary>
    /// GetPaymentHistory.
    /// </summary>
    procedure GetPaymentHistory()
    var
        paymentHistoryRec: Record "Fyorin Payment History";
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        PaymentObject: JsonObject;
        PaymentToken: JsonToken;
        PaymentArray: JsonArray;
        PaymenttokenInArray: JsonToken;
        PaymentTokenObject: JsonObject;
        payment2Token: JsonToken;
        Payment2Object: JsonObject;
        payment3Token: JsonToken;
        payment3object: JsonObject;
        PaymentId: Text;
        paymentIdToken: JsonToken;
        ProcessTime: BigInteger;
        ProcessTimetoken: JsonToken;
        ExpiryTime: BigInteger;
        Expirytimetoken: JsonToken;
        BeneficiaryId: text;
        BeneficiaryIdToken: JsonToken;
        BanId: Text;
        BanIdToken: JsonToken;
        Amount: Decimal;
        AmountToken: JsonToken;
        CurrCode: Code[20];
        CurrCodeToken: JsonToken;
        AmountObject: JsonObject;
        Amount1Token: JsonToken;
        DocNoReference: text;
        DocNoReferencetoken: JsonToken;
        state: Text;
        StateToken: JsonToken;
        CancelReason: text;
        CancelReasonToken: JsonToken;
        RejectReason: text;
        RejectReasonToken: JsonToken;
        BeneficiaryReference: text;
        BeneficiaryReferenceToken: JsonToken;
        LastUpdateTimeStamp: BigInteger;
        LastUpdateTimestampToken: JsonToken;
        Status: text;
        StatusToken: JsonToken;
        ContactToken: JsonToken;
        ContactObject: JsonObject;


    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);

        httpContents.WriteFrom('{}');
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/get';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');

        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ResponseText) then begin
                    if PaymentObject.ReadFrom(ResponseText) then begin

                        PaymentObject.SelectToken('payment', PaymentToken);
                        PaymentArray := PaymentToken.AsArray();

                        foreach PaymenttokenInArray in PaymentArray do begin

                            if PaymenttokenInArray.IsObject() then
                                PaymentTokenObject := PaymenttokenInArray.AsObject();

                            if PaymentTokenObject.Get('payment', payment2Token) then
                                Payment2Object := payment2Token.AsObject();

                            if Payment2Object.Get('payment', payment3Token) then
                                payment3object := payment3Token.AsObject();

                            if payment3object.Get('paymentId', paymentIdToken) then
                                PaymentId := paymentIdToken.AsValue().AsText();

                            if payment3object.Get('processTime', ProcessTimetoken) then
                                ProcessTime := ProcessTimetoken.AsValue().AsBigInteger();

                            if payment3object.Get('approvalExpiryTime', Expirytimetoken) then
                                ExpiryTime := Expirytimetoken.AsValue().AsBigInteger();

                            if payment3object.Get('beneficiaryId', BeneficiaryIdToken) then
                                BeneficiaryId := BeneficiaryIdToken.AsValue().AsText();

                            if payment3object.Get('banId', BanIdToken) then
                                BanId := BanIdToken.AsValue().AsText();

                            if payment3object.Get('amount', Amount1Token) then begin
                                AmountObject := Amount1Token.AsObject();
                                if AmountObject.Get('currency', CurrCodeToken) then
                                    CurrCode := CurrCodeToken.AsValue().AsCode();
                                if AmountObject.Get('amount', AmountToken) then
                                    Amount := AmountToken.AsValue().AsDecimal();
                            end;
                            if payment3object.Get('reference', DocNoReferencetoken) then
                                DocNoReference := DocNoReferencetoken.AsValue().AsText();
                            if payment3object.Get('state', StateToken) then
                                state := StateToken.AsValue().AsText();

                            if payment3object.Get('cancelReason', CancelReasonToken) then
                                CancelReason := CancelReasonToken.AsValue().AsText();

                            if payment3object.Get('rejectReason', RejectReasonToken) then
                                RejectReason := RejectReasonToken.AsValue().AsText();

                            if PaymentTokenObject.Get('contact', ContactToken) then begin
                                ContactObject := ContactToken.AsObject();

                                if ContactObject.Get('reference', BeneficiaryReferenceToken) then
                                    BeneficiaryReference := BeneficiaryReferenceToken.AsValue().AsText();

                                if ContactObject.Get('lastUpdateTimestamp', LastUpdateTimestampToken) then
                                    LastUpdateTimeStamp := LastUpdateTimestampToken.AsValue().AsBigInteger();
                                if ContactObject.Get('state', StatusToken) then
                                    status := StatusToken.AsValue().AsText();
                            end;
                            // Message('%1::%2', ConvertUnixTimeStampToDateTime(ProcessTime), ConvertUnixTimeStampToDateTime(ExpiryTime));
                            paymentHistoryRec.Reset();
                            paymentHistoryRec.SetRange("Payment Id", PaymentId);
                            if paymentHistoryRec.FindFirst() then begin
                                //  paymentHistoryRec."process Time" := ConvertUnixTimeStampToDateTime(ProcessTime);
                                //  paymentHistoryRec."Approval Expiry Time" := ConvertUnixTimeStampToDateTime(ExpiryTime);
                                paymentHistoryRec."Beneficiary Id" := BeneficiaryId;
                                paymentHistoryRec."Ban Id" := BanId;
                                paymentHistoryRec.Amount := Amount;
                                paymentHistoryRec.Currency := CurrCode;
                                paymentHistoryRec."Document No Reference" := DocNoReference;
                                paymentHistoryRec."Reject Reason" := RejectReason;
                                paymentHistoryRec."Cancel Reason" := CancelReason;
                                paymentHistoryRec.State := state;
                                paymentHistoryRec."Beneficiary Reference" := BeneficiaryReference;
                                paymentHistoryRec.Status := Status;
                                //    paymentHistoryRec."last update Timestamp" := ConvertUnixTimeStampToDateTime(LastUpdateTimeStamp);
                                paymentHistoryRec.Modify();
                            end
                            else begin


                                paymentHistoryRec.Reset();
                                paymentHistoryRec.SetRange("Payment Id", PaymentId);
                                if not paymentHistoryRec.FindFirst() then begin
                                    paymentHistoryRec.Init();
                                    paymentHistoryRec."Payment Id" := PaymentId;
                                    // paymentHistoryRec."process Time" := ConvertUnixTimeStampToDateTime(ProcessTime);
                                    // paymentHistoryRec."Approval Expiry Time" := ConvertUnixTimeStampToDateTime(ExpiryTime);
                                    paymentHistoryRec."Beneficiary Id" := BeneficiaryId;
                                    paymentHistoryRec."Ban Id" := BanId;
                                    paymentHistoryRec.Amount := Amount;
                                    paymentHistoryRec.Currency := CurrCode;
                                    paymentHistoryRec."Document No Reference" := DocNoReference;
                                    paymentHistoryRec."Reject Reason" := RejectReason;
                                    paymentHistoryRec."Cancel Reason" := CancelReason;
                                    paymentHistoryRec.State := state;
                                    paymentHistoryRec."Beneficiary Reference" := BeneficiaryReference;
                                    paymentHistoryRec.Status := Status;
                                    // paymentHistoryRec."last update Timestamp" := ConvertUnixTimeStampToDateTime(LastUpdateTimeStamp);
                                    paymentHistoryRec.Insert();
                                end
                            end;
                        end;
                        Message('Payment History Updated!');
                    end else
                        Error('Json File does not contain Payment Objects: (%1)', ResponseText);
                    //Message('%1', ResponseText);
                end else
                    Error('Invalid Json File');
            end else begin
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;

    end;

    Procedure CreatePayment(var VendorNo: Code[30]; CurrCode: Code[20]; Amount: Decimal; DocNo: Code[20])
    var
        ApiSetup: Record "Fyorin Setup";
        VendorREC: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        //ResponseContent: HttpResponseMessage
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        Jtext: text;
        Jobject: JsonObject;
        AmountObject: JsonObject;
        GeneratedId: text;
        httpResponseHeader: HttpHeaders;
        ArrayText: array[1] of Text;
        DatetimeUtcText: text;
        TypeHelper: Codeunit "Type Helper";
        ProcessTimeText: text;
        Processtime: BigInteger;
        ExpiryTime: BigInteger;
        ExpiryDate: DateTime;
        ExDate: Date;
        BanIntger: BigInteger;
        iban: text;
        bankcurrency: text;

    begin
        ClearAll();
        VendorREC.Get(VendorNo);
        VendorBankAccount.SetRange("Vendor No.", VendorNo);
        if VendorBankAccount.FindFirst() then begin

            iban := VendorBankAccount.IBAN;
            bankcurrency := VendorBankAccount."Currency Code";

        end;
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        ProcessTime := Round((GetUnixTimeStamp(CurrentDateTime)), 1, '<');
        ExDate := CalcDate('1D', Today);
        ExpiryDate := System.CreateDateTime(ExDate, 0T);
        ExpiryTime := Round((GetUnixTimeStamp(ExpiryDate)), 1, '<');


        Jobject.Add('beneficiaryReference', VendorNo);
        Jobject.Add('banId', '108594738475630856');
        AmountObject.Add('currency', CurrCode);
        AmountObject.Add('amount', Amount);
        Jobject.Add('amount', AmountObject);
        Jobject.Add('processTime', ProcessTime);
        Jobject.Add('approvalExpiryTime', ExpiryTime);
        Jobject.Add('reference', DocNo);
        //Jobject.Add('reason', 'ADMINISTRATIVE__PURCHASE');
        //Jobject.Add('purposeCode', 'BH__GDE');
        Jobject.WriteTo(Jtext);

        httpContents.WriteFrom(Jtext);
        // httpContents.WriteFrom('{"beneficiaryReference":"VEND0002","banId":"10000001112","amount":{"currency":"EUR","amount":"1000"},"processTime":"1658390703000","approvalExpiryTime":"1658400723000","reference":"INV0001","reason":"ADMINISTRATIVE__PURCHASE"}');
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/_/create';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');
        //Message('%1', Jtext);
        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content().ReadAs(ResponseText) then begin
                    //Response.Content().GetHeaders(httpResponseHeader);
                    httpResponseHeader := Response.Headers();

                    if httpResponseHeader.Contains('generated-id') then begin
                        httpResponseHeader.GetValues('generated-id', ArrayText);
                        GeneratedId := ArrayText[1];
                        Message('Payment Created, generated Id: %1 ', GeneratedId);
                        //Message('Payment Created');
                    end;
                end else
                    Error('Invalid Json File');
            end else begin
                if Response.Content().ReadAs(ContentTXT) then
                    error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
            end;
        end;

    end;

    /// <summary>
    /// ApprovePayment.
    /// </summary>
    /// <param name="paymentId">VAR text.</param>
    procedure ApprovePayment(var paymentId: text)
    var
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        /* HttpHeader.Clear();
         HttpHeader.Add('Content-Type', 'application/json');
         request.GetHeaders(HttpHeader);
         HttpHeader.Add('Authorization', 'Bearer ' + TokenText); */
        RequestString := ApiSetup.URL + '/api/payments/' + paymentId + '/approve';
        Request.SetRequestUri(RequestString);
        Request.Method('POST');
        Client.DefaultRequestHeaders().Add('Authorization', 'Bearer ' + TokenText);
        //if Client.Send(Request, Response) then begin
        if Client.Get(RequestString, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Message('Payments Approved Successfully');

            end else
                if Response.Content().ReadAs(ContentTXT) then
                    Error('%1', ContentTXT);
        end else
            if Response.Content().ReadAs(ContentTXT) then
                error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
    end;


    /// <summary>
    /// RejectPayments.
    /// </summary>
    /// <param name="paymentId">VAR text.</param>
    /// <param name="reason">text.</param>
    procedure RejectPayments(var paymentId: text; reason: text)
    var
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        Jobject: JsonObject;
        Jtext: Text;
    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        Jobject.Add('reason', reason);
        Jobject.WriteTo(Jtext);
        httpContents.WriteFrom(Jtext);
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/' + paymentId + '/reject';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');
        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Message('Payments Rejected');

            end else
                if Response.Content().ReadAs(ContentTXT) then
                    Error('%1', ContentTXT);
        end else
            if Response.Content().ReadAs(ContentTXT) then
                error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
    end;

    /// <summary>
    /// CancelPayment.
    /// </summary>
    /// <param name="paymentId">VAR text.</param>
    /// <param name="reason">text.</param>
    procedure CancelPayment(var paymentId: text; reason: text)
    var
        ApiSetup: Record "Fyorin Setup";
        Client: HttpClient;
        httpContents: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        ContentTXT: Text;
        RequestString: text;
        ResponseText: text;
        TokenText: text;
        Jobject: JsonObject;
        Jtext: Text;
    begin
        ApiSetup.Get();
        TokenText := HttpRequest(ApiSetup."Api Token", ApiSetup.accessor_api_key_email, ApiSetup.accessor_owner_password, ApiSetup.accessor_api_key_password, ApiSetup.URL);
        Jobject.Add('reason', reason);
        Jobject.WriteTo(Jtext);
        httpContents.WriteFrom(Jtext);
        httpContents.GetHeaders(HttpHeader);
        HttpHeader.Clear();
        HttpHeader.Add('Content-Type', 'application/json');
        request.GetHeaders(HttpHeader);
        HttpHeader.Add('Authorization', 'Bearer ' + TokenText);
        RequestString := ApiSetup.URL + '/api/payments/' + paymentId + '/cancel';
        Request.SetRequestUri(RequestString);
        Request.Content := httpContents;
        Request.Method('POST');
        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                Message('Payments has been Cancelled');

            end else
                if Response.Content().ReadAs(ContentTXT) then
                    Error('%1', ContentTXT);
        end else
            if Response.Content().ReadAs(ContentTXT) then
                error('Http Request Failed, return value(%1)(%2)', Response.HttpStatusCode(), ContentTXT)
    end;

    /// <summary>
    /// GetUnixTimeStamp.
    /// </summary>
    /// <param name="FromDateTime">DateTime.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetUnixTimeStamp(FromDateTime: DateTime): Decimal
    var
        TypeHelper: Codeunit "Type Helper";
        OriginDateTime: DateTime;
        TimeZoneOffset: Duration;
    begin
        TypeHelper.GetUserTimezoneOffset(TimeZoneOffset);
        OriginDateTime := System.CreateDateTime(DMY2Date(1, 1, 1970), 0T);
        OriginDateTime := OriginDateTime + TimeZoneOffset;
        exit(FromDateTime - OriginDateTime);

    end;
    /// <summary>
    /// ConvertUnixTimeStampToDateTime.
    /// </summary>
    /// <param name="Timestamp">VAR BigInteger.</param>
    /// <returns>Return value of type DateTime.</returns>
    procedure ConvertUnixTimeStampToDateTime(var Timestamp: BigInteger): DateTime
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        exit(TypeHelper.EvaluateUnixTimestamp(Timestamp))
    end;
}
