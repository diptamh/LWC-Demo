public with sharing class HTTPCallout {
    Http h;
    HttpRequest req;
    HttpResponse res;
    public HTTPCallout(){
        this.h = new Http();
        this.req = new HttpRequest();
        this.res = new HttpResponse();
    }

    public HTTPCallout setEndpoint(String url){
        this.req.setEndpoint(url);
        return this;
    }

    public HTTPCallout setBody(String body){
        this.req.setBody(body);
        return this;
    }

    public HTTPCallout setMethod(String method){
        this.req.setMethod(method);
        return this;
    }

    public HTTPCallout send(){
        this.res = h.send(req);
        return this;
    }

    public string getStatus(){
        return this.res.getStatus();
    }

    public string getBody(){
        return this.res.getBody();
    }
}