package it.ht.rcs.console.operations.view.configuration.advanced.renderers
{
  import flash.geom.Point;

  public interface Linkable
  {
    
    function inBoundConnections():Vector.<Connection>; // Of Connection. Why not a Vector? Because removing from vectors is a PITA
    function outBoundConnections():Vector.<Connection>;
    
    function getLinkPoint():Point;
    
  }
  
}