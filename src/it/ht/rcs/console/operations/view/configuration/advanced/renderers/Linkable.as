package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.geom.Point;

  public interface Linkable
  {
    
    function inBoundConnections():Vector.<Connection>;
    function outBoundConnections():Vector.<Connection>;
    
    function getLinkPoint():Point;
    
  }
  
}