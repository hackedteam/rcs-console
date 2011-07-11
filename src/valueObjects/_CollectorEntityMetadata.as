
/**
 * This is a generated class and is not intended for modification.  
 */
package valueObjects
{
import com.adobe.fiber.styles.IStyle;
import com.adobe.fiber.styles.Style;
import com.adobe.fiber.styles.StyleValidator;
import com.adobe.fiber.valueobjects.AbstractEntityMetadata;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IModelType;
import mx.events.PropertyChangeEvent;

use namespace model_internal;

[ExcludeClass]
internal class _CollectorEntityMetadata extends com.adobe.fiber.valueobjects.AbstractEntityMetadata
{
    private static var emptyArray:Array = new Array();

    model_internal static var allProperties:Array = new Array("port", "desc", "configured", "next", "type", "version", "prev", "updated_at", "poll", "_id", "address", "name", "created_at", "_mid", "instance");
    model_internal static var allAssociationProperties:Array = new Array();
    model_internal static var allRequiredProperties:Array = new Array("next", "version", "prev", "_mid", "instance");
    model_internal static var allAlwaysAvailableProperties:Array = new Array("port", "desc", "configured", "next", "type", "version", "prev", "updated_at", "poll", "_id", "address", "name", "created_at", "_mid", "instance");
    model_internal static var guardedProperties:Array = new Array();
    model_internal static var dataProperties:Array = new Array("port", "desc", "configured", "next", "type", "version", "prev", "updated_at", "poll", "_id", "address", "name", "created_at", "_mid", "instance");
    model_internal static var sourceProperties:Array = emptyArray
    model_internal static var nonDerivedProperties:Array = new Array("port", "desc", "configured", "next", "type", "version", "prev", "updated_at", "poll", "_id", "address", "name", "created_at", "_mid", "instance");
    model_internal static var derivedProperties:Array = new Array();
    model_internal static var collectionProperties:Array = new Array("next", "prev");
    model_internal static var collectionBaseMap:Object;
    model_internal static var entityName:String = "Collector";
    model_internal static var dependentsOnMap:Object;
    model_internal static var dependedOnServices:Array = new Array();
    model_internal static var propertyTypeMap:Object;

    
    model_internal var _nextIsValid:Boolean;
    model_internal var _nextValidator:com.adobe.fiber.styles.StyleValidator;
    model_internal var _nextIsValidCacheInitialized:Boolean = false;
    model_internal var _nextValidationFailureMessages:Array;
    
    model_internal var _prevIsValid:Boolean;
    model_internal var _prevValidator:com.adobe.fiber.styles.StyleValidator;
    model_internal var _prevIsValidCacheInitialized:Boolean = false;
    model_internal var _prevValidationFailureMessages:Array;
    
    model_internal var _instanceIsValid:Boolean;
    model_internal var _instanceValidator:com.adobe.fiber.styles.StyleValidator;
    model_internal var _instanceIsValidCacheInitialized:Boolean = false;
    model_internal var _instanceValidationFailureMessages:Array;

    model_internal var _instance:_Super_Collector;
    model_internal static var _nullStyle:com.adobe.fiber.styles.Style = new com.adobe.fiber.styles.Style();

    public function _CollectorEntityMetadata(value : _Super_Collector)
    {
        // initialize property maps
        if (model_internal::dependentsOnMap == null)
        {
            // dependents map
            model_internal::dependentsOnMap = new Object();
            model_internal::dependentsOnMap["port"] = new Array();
            model_internal::dependentsOnMap["desc"] = new Array();
            model_internal::dependentsOnMap["configured"] = new Array();
            model_internal::dependentsOnMap["next"] = new Array();
            model_internal::dependentsOnMap["type"] = new Array();
            model_internal::dependentsOnMap["version"] = new Array();
            model_internal::dependentsOnMap["prev"] = new Array();
            model_internal::dependentsOnMap["updated_at"] = new Array();
            model_internal::dependentsOnMap["poll"] = new Array();
            model_internal::dependentsOnMap["_id"] = new Array();
            model_internal::dependentsOnMap["address"] = new Array();
            model_internal::dependentsOnMap["name"] = new Array();
            model_internal::dependentsOnMap["created_at"] = new Array();
            model_internal::dependentsOnMap["_mid"] = new Array();
            model_internal::dependentsOnMap["instance"] = new Array();

            // collection base map
            model_internal::collectionBaseMap = new Object();
            model_internal::collectionBaseMap["next"] = "String";
            model_internal::collectionBaseMap["prev"] = "String";
        }

        // Property type Map
        model_internal::propertyTypeMap = new Object();
        model_internal::propertyTypeMap["port"] = "int";
        model_internal::propertyTypeMap["desc"] = "String";
        model_internal::propertyTypeMap["configured"] = "Boolean";
        model_internal::propertyTypeMap["next"] = "ArrayCollection";
        model_internal::propertyTypeMap["type"] = "String";
        model_internal::propertyTypeMap["version"] = "int";
        model_internal::propertyTypeMap["prev"] = "ArrayCollection";
        model_internal::propertyTypeMap["updated_at"] = "String";
        model_internal::propertyTypeMap["poll"] = "Boolean";
        model_internal::propertyTypeMap["_id"] = "String";
        model_internal::propertyTypeMap["address"] = "String";
        model_internal::propertyTypeMap["name"] = "String";
        model_internal::propertyTypeMap["created_at"] = "String";
        model_internal::propertyTypeMap["_mid"] = "int";
        model_internal::propertyTypeMap["instance"] = "String";

        model_internal::_instance = value;
        model_internal::_nextValidator = new StyleValidator(model_internal::_instance.model_internal::_doValidationForNext);
        model_internal::_nextValidator.required = true;
        model_internal::_nextValidator.requiredFieldError = "next is required";
        //model_internal::_nextValidator.source = model_internal::_instance;
        //model_internal::_nextValidator.property = "next";
        model_internal::_prevValidator = new StyleValidator(model_internal::_instance.model_internal::_doValidationForPrev);
        model_internal::_prevValidator.required = true;
        model_internal::_prevValidator.requiredFieldError = "prev is required";
        //model_internal::_prevValidator.source = model_internal::_instance;
        //model_internal::_prevValidator.property = "prev";
        model_internal::_instanceValidator = new StyleValidator(model_internal::_instance.model_internal::_doValidationForInstance);
        model_internal::_instanceValidator.required = true;
        model_internal::_instanceValidator.requiredFieldError = "instance is required";
        //model_internal::_instanceValidator.source = model_internal::_instance;
        //model_internal::_instanceValidator.property = "instance";
    }

    override public function getEntityName():String
    {
        return model_internal::entityName;
    }

    override public function getProperties():Array
    {
        return model_internal::allProperties;
    }

    override public function getAssociationProperties():Array
    {
        return model_internal::allAssociationProperties;
    }

    override public function getRequiredProperties():Array
    {
         return model_internal::allRequiredProperties;   
    }

    override public function getDataProperties():Array
    {
        return model_internal::dataProperties;
    }

    public function getSourceProperties():Array
    {
        return model_internal::sourceProperties;
    }

    public function getNonDerivedProperties():Array
    {
        return model_internal::nonDerivedProperties;
    }

    override public function getGuardedProperties():Array
    {
        return model_internal::guardedProperties;
    }

    override public function getUnguardedProperties():Array
    {
        return model_internal::allAlwaysAvailableProperties;
    }

    override public function getDependants(propertyName:String):Array
    {
       if (model_internal::nonDerivedProperties.indexOf(propertyName) == -1)
            throw new Error(propertyName + " is not a data property of entity Collector");
            
       return model_internal::dependentsOnMap[propertyName] as Array;  
    }

    override public function getDependedOnServices():Array
    {
        return model_internal::dependedOnServices;
    }

    override public function getCollectionProperties():Array
    {
        return model_internal::collectionProperties;
    }

    override public function getCollectionBase(propertyName:String):String
    {
        if (model_internal::collectionProperties.indexOf(propertyName) == -1)
            throw new Error(propertyName + " is not a collection property of entity Collector");

        return model_internal::collectionBaseMap[propertyName];
    }
    
    override public function getPropertyType(propertyName:String):String
    {
        if (model_internal::allProperties.indexOf(propertyName) == -1)
            throw new Error(propertyName + " is not a property of Collector");

        return model_internal::propertyTypeMap[propertyName];
    }

    override public function getAvailableProperties():com.adobe.fiber.valueobjects.IPropertyIterator
    {
        return new com.adobe.fiber.valueobjects.AvailablePropertyIterator(this);
    }

    override public function getValue(propertyName:String):*
    {
        if (model_internal::allProperties.indexOf(propertyName) == -1)
        {
            throw new Error(propertyName + " does not exist for entity Collector");
        }

        return model_internal::_instance[propertyName];
    }

    override public function setValue(propertyName:String, value:*):void
    {
        if (model_internal::nonDerivedProperties.indexOf(propertyName) == -1)
        {
            throw new Error(propertyName + " is not a modifiable property of entity Collector");
        }

        model_internal::_instance[propertyName] = value;
    }

    override public function getMappedByProperty(associationProperty:String):String
    {
        switch(associationProperty)
        {
            default:
            {
                return null;
            }
        }
    }

    override public function getPropertyLength(propertyName:String):int
    {
        switch(propertyName)
        {
            default:
            {
                return 0;
            }
        }
    }

    override public function isAvailable(propertyName:String):Boolean
    {
        if (model_internal::allProperties.indexOf(propertyName) == -1)
        {
            throw new Error(propertyName + " does not exist for entity Collector");
        }

        if (model_internal::allAlwaysAvailableProperties.indexOf(propertyName) != -1)
        {
            return true;
        }

        switch(propertyName)
        {
            default:
            {
                return true;
            }
        }
    }

    override public function getIdentityMap():Object
    {
        var returnMap:Object = new Object();

        return returnMap;
    }

    [Bindable(event="propertyChange")]
    override public function get invalidConstraints():Array
    {
        if (model_internal::_instance.model_internal::_cacheInitialized_isValid)
        {
            return model_internal::_instance.model_internal::_invalidConstraints;
        }
        else
        {
            // recalculate isValid
            model_internal::_instance.model_internal::_isValid = model_internal::_instance.model_internal::calculateIsValid();
            return model_internal::_instance.model_internal::_invalidConstraints;        
        }
    }

    [Bindable(event="propertyChange")]
    override public function get validationFailureMessages():Array
    {
        if (model_internal::_instance.model_internal::_cacheInitialized_isValid)
        {
            return model_internal::_instance.model_internal::_validationFailureMessages;
        }
        else
        {
            // recalculate isValid
            model_internal::_instance.model_internal::_isValid = model_internal::_instance.model_internal::calculateIsValid();
            return model_internal::_instance.model_internal::_validationFailureMessages;
        }
    }

    override public function getDependantInvalidConstraints(propertyName:String):Array
    {
        var dependants:Array = getDependants(propertyName);
        if (dependants.length == 0)
        {
            return emptyArray;
        }

        var currentlyInvalid:Array = invalidConstraints;
        if (currentlyInvalid.length == 0)
        {
            return emptyArray;
        }

        var filterFunc:Function = function(element:*, index:int, arr:Array):Boolean
        {
            return dependants.indexOf(element) > -1;
        }

        return currentlyInvalid.filter(filterFunc);
    }

    /**
     * isValid
     */
    [Bindable(event="propertyChange")] 
    public function get isValid() : Boolean
    {
        if (model_internal::_instance.model_internal::_cacheInitialized_isValid)
        {
            return model_internal::_instance.model_internal::_isValid;
        }
        else
        {
            // recalculate isValid
            model_internal::_instance.model_internal::_isValid = model_internal::_instance.model_internal::calculateIsValid();
            return model_internal::_instance.model_internal::_isValid;
        }
    }

    [Bindable(event="propertyChange")]
    public function get isPortAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isDescAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isConfiguredAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isNextAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isTypeAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isVersionAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isPrevAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isUpdated_atAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isPollAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get is_idAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isAddressAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isNameAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isCreated_atAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get is_midAvailable():Boolean
    {
        return true;
    }

    [Bindable(event="propertyChange")]
    public function get isInstanceAvailable():Boolean
    {
        return true;
    }


    /**
     * derived property recalculation
     */
    public function invalidateDependentOnNext():void
    {
        if (model_internal::_nextIsValidCacheInitialized )
        {
            model_internal::_instance.model_internal::_doValidationCacheOfNext = null;
            model_internal::calculateNextIsValid();
        }
    }
    public function invalidateDependentOnPrev():void
    {
        if (model_internal::_prevIsValidCacheInitialized )
        {
            model_internal::_instance.model_internal::_doValidationCacheOfPrev = null;
            model_internal::calculatePrevIsValid();
        }
    }
    public function invalidateDependentOnInstance():void
    {
        if (model_internal::_instanceIsValidCacheInitialized )
        {
            model_internal::_instance.model_internal::_doValidationCacheOfInstance = null;
            model_internal::calculateInstanceIsValid();
        }
    }

    model_internal function fireChangeEvent(propertyName:String, oldValue:Object, newValue:Object):void
    {
        this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, propertyName, oldValue, newValue));
    }

    [Bindable(event="propertyChange")]   
    public function get portStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get descStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get configuredStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get nextStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    public function get nextValidator() : StyleValidator
    {
        return model_internal::_nextValidator;
    }

    model_internal function set _nextIsValid_der(value:Boolean):void 
    {
        var oldValue:Boolean = model_internal::_nextIsValid;         
        if (oldValue !== value)
        {
            model_internal::_nextIsValid = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "nextIsValid", oldValue, value));
        }                             
    }

    [Bindable(event="propertyChange")]
    public function get nextIsValid():Boolean
    {
        if (!model_internal::_nextIsValidCacheInitialized)
        {
            model_internal::calculateNextIsValid();
        }

        return model_internal::_nextIsValid;
    }

    model_internal function calculateNextIsValid():void
    {
        var valRes:ValidationResultEvent = model_internal::_nextValidator.validate(model_internal::_instance.next)
        model_internal::_nextIsValid_der = (valRes.results == null);
        model_internal::_nextIsValidCacheInitialized = true;
        if (valRes.results == null)
             model_internal::nextValidationFailureMessages_der = emptyArray;
        else
        {
            var _valFailures:Array = new Array();
            for (var a:int = 0 ; a<valRes.results.length ; a++)
            {
                _valFailures.push(valRes.results[a].errorMessage);
            }
            model_internal::nextValidationFailureMessages_der = _valFailures;
        }
    }

    [Bindable(event="propertyChange")]
    public function get nextValidationFailureMessages():Array
    {
        if (model_internal::_nextValidationFailureMessages == null)
            model_internal::calculateNextIsValid();

        return _nextValidationFailureMessages;
    }

    model_internal function set nextValidationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_nextValidationFailureMessages;

        var needUpdate : Boolean = false;
        if (oldValue == null)
            needUpdate = true;
    
        // avoid firing the event when old and new value are different empty arrays
        if (!needUpdate && (oldValue !== value && (oldValue.length > 0 || value.length > 0)))
        {
            if (oldValue.length == value.length)
            {
                for (var a:int=0; a < oldValue.length; a++)
                {
                    if (oldValue[a] !== value[a])
                    {
                        needUpdate = true;
                        break;
                    }
                }
            }
            else
            {
                needUpdate = true;
            }
        }

        if (needUpdate)
        {
            model_internal::_nextValidationFailureMessages = value;   
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "nextValidationFailureMessages", oldValue, value));
            // Only execute calculateIsValid if it has been called before, to update the validationFailureMessages for
            // the entire entity.
            if (model_internal::_instance.model_internal::_cacheInitialized_isValid)
            {
                model_internal::_instance.model_internal::isValid_der = model_internal::_instance.model_internal::calculateIsValid();
            }
        }
    }

    [Bindable(event="propertyChange")]   
    public function get typeStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get versionStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get prevStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    public function get prevValidator() : StyleValidator
    {
        return model_internal::_prevValidator;
    }

    model_internal function set _prevIsValid_der(value:Boolean):void 
    {
        var oldValue:Boolean = model_internal::_prevIsValid;         
        if (oldValue !== value)
        {
            model_internal::_prevIsValid = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "prevIsValid", oldValue, value));
        }                             
    }

    [Bindable(event="propertyChange")]
    public function get prevIsValid():Boolean
    {
        if (!model_internal::_prevIsValidCacheInitialized)
        {
            model_internal::calculatePrevIsValid();
        }

        return model_internal::_prevIsValid;
    }

    model_internal function calculatePrevIsValid():void
    {
        var valRes:ValidationResultEvent = model_internal::_prevValidator.validate(model_internal::_instance.prev)
        model_internal::_prevIsValid_der = (valRes.results == null);
        model_internal::_prevIsValidCacheInitialized = true;
        if (valRes.results == null)
             model_internal::prevValidationFailureMessages_der = emptyArray;
        else
        {
            var _valFailures:Array = new Array();
            for (var a:int = 0 ; a<valRes.results.length ; a++)
            {
                _valFailures.push(valRes.results[a].errorMessage);
            }
            model_internal::prevValidationFailureMessages_der = _valFailures;
        }
    }

    [Bindable(event="propertyChange")]
    public function get prevValidationFailureMessages():Array
    {
        if (model_internal::_prevValidationFailureMessages == null)
            model_internal::calculatePrevIsValid();

        return _prevValidationFailureMessages;
    }

    model_internal function set prevValidationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_prevValidationFailureMessages;

        var needUpdate : Boolean = false;
        if (oldValue == null)
            needUpdate = true;
    
        // avoid firing the event when old and new value are different empty arrays
        if (!needUpdate && (oldValue !== value && (oldValue.length > 0 || value.length > 0)))
        {
            if (oldValue.length == value.length)
            {
                for (var a:int=0; a < oldValue.length; a++)
                {
                    if (oldValue[a] !== value[a])
                    {
                        needUpdate = true;
                        break;
                    }
                }
            }
            else
            {
                needUpdate = true;
            }
        }

        if (needUpdate)
        {
            model_internal::_prevValidationFailureMessages = value;   
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "prevValidationFailureMessages", oldValue, value));
            // Only execute calculateIsValid if it has been called before, to update the validationFailureMessages for
            // the entire entity.
            if (model_internal::_instance.model_internal::_cacheInitialized_isValid)
            {
                model_internal::_instance.model_internal::isValid_der = model_internal::_instance.model_internal::calculateIsValid();
            }
        }
    }

    [Bindable(event="propertyChange")]   
    public function get updated_atStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get pollStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get _idStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get addressStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get nameStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get created_atStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get _midStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    [Bindable(event="propertyChange")]   
    public function get instanceStyle():com.adobe.fiber.styles.Style
    {
        return model_internal::_nullStyle;
    }

    public function get instanceValidator() : StyleValidator
    {
        return model_internal::_instanceValidator;
    }

    model_internal function set _instanceIsValid_der(value:Boolean):void 
    {
        var oldValue:Boolean = model_internal::_instanceIsValid;         
        if (oldValue !== value)
        {
            model_internal::_instanceIsValid = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "instanceIsValid", oldValue, value));
        }                             
    }

    [Bindable(event="propertyChange")]
    public function get instanceIsValid():Boolean
    {
        if (!model_internal::_instanceIsValidCacheInitialized)
        {
            model_internal::calculateInstanceIsValid();
        }

        return model_internal::_instanceIsValid;
    }

    model_internal function calculateInstanceIsValid():void
    {
        var valRes:ValidationResultEvent = model_internal::_instanceValidator.validate(model_internal::_instance.instance)
        model_internal::_instanceIsValid_der = (valRes.results == null);
        model_internal::_instanceIsValidCacheInitialized = true;
        if (valRes.results == null)
             model_internal::instanceValidationFailureMessages_der = emptyArray;
        else
        {
            var _valFailures:Array = new Array();
            for (var a:int = 0 ; a<valRes.results.length ; a++)
            {
                _valFailures.push(valRes.results[a].errorMessage);
            }
            model_internal::instanceValidationFailureMessages_der = _valFailures;
        }
    }

    [Bindable(event="propertyChange")]
    public function get instanceValidationFailureMessages():Array
    {
        if (model_internal::_instanceValidationFailureMessages == null)
            model_internal::calculateInstanceIsValid();

        return _instanceValidationFailureMessages;
    }

    model_internal function set instanceValidationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_instanceValidationFailureMessages;

        var needUpdate : Boolean = false;
        if (oldValue == null)
            needUpdate = true;
    
        // avoid firing the event when old and new value are different empty arrays
        if (!needUpdate && (oldValue !== value && (oldValue.length > 0 || value.length > 0)))
        {
            if (oldValue.length == value.length)
            {
                for (var a:int=0; a < oldValue.length; a++)
                {
                    if (oldValue[a] !== value[a])
                    {
                        needUpdate = true;
                        break;
                    }
                }
            }
            else
            {
                needUpdate = true;
            }
        }

        if (needUpdate)
        {
            model_internal::_instanceValidationFailureMessages = value;   
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "instanceValidationFailureMessages", oldValue, value));
            // Only execute calculateIsValid if it has been called before, to update the validationFailureMessages for
            // the entire entity.
            if (model_internal::_instance.model_internal::_cacheInitialized_isValid)
            {
                model_internal::_instance.model_internal::isValid_der = model_internal::_instance.model_internal::calculateIsValid();
            }
        }
    }


     /**
     * 
     * @inheritDoc 
     */ 
     override public function getStyle(propertyName:String):com.adobe.fiber.styles.IStyle
     {
         switch(propertyName)
         {
            default:
            {
                return null;
            }
         }
     }
     
     /**
     * 
     * @inheritDoc 
     *  
     */  
     override public function getPropertyValidationFailureMessages(propertyName:String):Array
     {
         switch(propertyName)
         {
            case("next"):
            {
                return nextValidationFailureMessages;
            }
            case("prev"):
            {
                return prevValidationFailureMessages;
            }
            case("instance"):
            {
                return instanceValidationFailureMessages;
            }
            default:
            {
                return emptyArray;
            }
         }
     }

}

}
