package it.ht.rcs.console.model
{
  public class Monitor
  {
    [Bindable]
    public var _id:String;
    [Bindable]
    public var name:String;
    [Bindable]
    public var status:String;
    [Bindable]
    public var address:String;
    [Bindable]
    public var info:String;
    [Bindable]
    public var time:Number;
    [Bindable]
    public var cpu:Number;
    [Bindable]
    public var cput:Number;
    [Bindable]
    public var df:Number;
    
    public function Monitor(data:Object)
    {
      _id = data._id;
      name = data.name;
      status = data.status;
      address = data.address;
      info = data.info;
      time = data.time;
      cpu = data.cpu;
      cput = data.cput;
      df = data.df;
    }
    
  }
}