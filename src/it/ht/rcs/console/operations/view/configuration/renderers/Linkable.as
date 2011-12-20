package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.geom.Point;
  
  import mx.collections.ArrayCollection;

  public interface Linkable
  {
    
    function inBoundConnections():ArrayCollection; // Of Connection. Why not a Vector? Because removing from vectors is a PITA
    function outBoundConnections():ArrayCollection;
    
    function getLinkPoint():Point;
    
  }
  
}