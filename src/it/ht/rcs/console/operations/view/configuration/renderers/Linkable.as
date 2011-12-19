package it.ht.rcs.console.operations.view.configuration.renderers
{
  import flash.geom.Point;

  public interface Linkable
  {
    
    function getInBound():ConnectionLine;
    function setInBound(conn:ConnectionLine):void;
  
    function getOutBound():ConnectionLine;
    function setOutBound(conn:ConnectionLine):void;
    
    function getLinkPoint():Point;
    
  }
  
}