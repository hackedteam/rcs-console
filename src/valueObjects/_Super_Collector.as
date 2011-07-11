/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Collector.as.
 */

package valueObjects
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.util.FiberUtils;
import com.adobe.fiber.valueobjects.IValueObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import mx.binding.utils.ChangeWatcher;
import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;
import mx.events.PropertyChangeEvent;
import mx.validators.ValidationResult;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[ExcludeClass]
public class _Super_Collector extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _CollectorEntityMetadata;
    model_internal var _changedObjects:mx.collections.ArrayCollection = new ArrayCollection();

    public function getChangedObjects() : Array
    {
        _changedObjects.addItemAt(this,0);
        return _changedObjects.source;
    }

    public function clearChangedObjects() : void
    {
        _changedObjects.removeAll();
    }

    /**
     * properties
     */
    private var _internal_port : int;
    private var _internal_desc : String;
    private var _internal_configured : Boolean;
    private var _internal_next : ArrayCollection;
    private var _internal_type : String;
    private var _internal_version : int;
    private var _internal_prev : ArrayCollection;
    private var _internal_updated_at : String;
    private var _internal_poll : Boolean;
    private var _internal__id : String;
    private var _internal_address : String;
    private var _internal_name : String;
    private var _internal_created_at : String;
    private var _internal__mid : int;
    private var _internal_instance : String;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_Collector()
    {
        _model = new _CollectorEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "next", model_internal::setterListenerNext));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "prev", model_internal::setterListenerPrev));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "instance", model_internal::setterListenerInstance));

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get port() : int
    {
        return _internal_port;
    }

    [Bindable(event="propertyChange")]
    public function get desc() : String
    {
        return _internal_desc;
    }

    [Bindable(event="propertyChange")]
    public function get configured() : Boolean
    {
        return _internal_configured;
    }

    [Bindable(event="propertyChange")]
    public function get next() : ArrayCollection
    {
        return _internal_next;
    }

    [Bindable(event="propertyChange")]
    public function get type() : String
    {
        return _internal_type;
    }

    [Bindable(event="propertyChange")]
    public function get version() : int
    {
        return _internal_version;
    }

    [Bindable(event="propertyChange")]
    public function get prev() : ArrayCollection
    {
        return _internal_prev;
    }

    [Bindable(event="propertyChange")]
    public function get updated_at() : String
    {
        return _internal_updated_at;
    }

    [Bindable(event="propertyChange")]
    public function get poll() : Boolean
    {
        return _internal_poll;
    }

    [Bindable(event="propertyChange")]
    public function get _id() : String
    {
        return _internal__id;
    }

    [Bindable(event="propertyChange")]
    public function get address() : String
    {
        return _internal_address;
    }

    [Bindable(event="propertyChange")]
    public function get name() : String
    {
        return _internal_name;
    }

    [Bindable(event="propertyChange")]
    public function get created_at() : String
    {
        return _internal_created_at;
    }

    [Bindable(event="propertyChange")]
    public function get _mid() : int
    {
        return _internal__mid;
    }

    [Bindable(event="propertyChange")]
    public function get instance() : String
    {
        return _internal_instance;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set port(value:int) : void
    {
        var oldValue:int = _internal_port;
        if (oldValue !== value)
        {
            _internal_port = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "port", oldValue, _internal_port));
        }
    }

    public function set desc(value:String) : void
    {
        var oldValue:String = _internal_desc;
        if (oldValue !== value)
        {
            _internal_desc = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "desc", oldValue, _internal_desc));
        }
    }

    public function set configured(value:Boolean) : void
    {
        var oldValue:Boolean = _internal_configured;
        if (oldValue !== value)
        {
            _internal_configured = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "configured", oldValue, _internal_configured));
        }
    }

    public function set next(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_next;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_next = value;
            }
            else if (value is Array)
            {
                _internal_next = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_next = null;
            }
            else
            {
                throw new Error("value of next must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "next", oldValue, _internal_next));
        }
    }

    public function set type(value:String) : void
    {
        var oldValue:String = _internal_type;
        if (oldValue !== value)
        {
            _internal_type = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "type", oldValue, _internal_type));
        }
    }

    public function set version(value:int) : void
    {
        var oldValue:int = _internal_version;
        if (oldValue !== value)
        {
            _internal_version = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "version", oldValue, _internal_version));
        }
    }

    public function set prev(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_prev;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_prev = value;
            }
            else if (value is Array)
            {
                _internal_prev = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_prev = null;
            }
            else
            {
                throw new Error("value of prev must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "prev", oldValue, _internal_prev));
        }
    }

    public function set updated_at(value:String) : void
    {
        var oldValue:String = _internal_updated_at;
        if (oldValue !== value)
        {
            _internal_updated_at = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "updated_at", oldValue, _internal_updated_at));
        }
    }

    public function set poll(value:Boolean) : void
    {
        var oldValue:Boolean = _internal_poll;
        if (oldValue !== value)
        {
            _internal_poll = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "poll", oldValue, _internal_poll));
        }
    }

    public function set _id(value:String) : void
    {
        var oldValue:String = _internal__id;
        if (oldValue !== value)
        {
            _internal__id = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_id", oldValue, _internal__id));
        }
    }

    public function set address(value:String) : void
    {
        var oldValue:String = _internal_address;
        if (oldValue !== value)
        {
            _internal_address = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "address", oldValue, _internal_address));
        }
    }

    public function set name(value:String) : void
    {
        var oldValue:String = _internal_name;
        if (oldValue !== value)
        {
            _internal_name = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "name", oldValue, _internal_name));
        }
    }

    public function set created_at(value:String) : void
    {
        var oldValue:String = _internal_created_at;
        if (oldValue !== value)
        {
            _internal_created_at = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "created_at", oldValue, _internal_created_at));
        }
    }

    public function set _mid(value:int) : void
    {
        var oldValue:int = _internal__mid;
        if (oldValue !== value)
        {
            _internal__mid = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_mid", oldValue, _internal__mid));
        }
    }

    public function set instance(value:String) : void
    {
        var oldValue:String = _internal_instance;
        if (oldValue !== value)
        {
            _internal_instance = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "instance", oldValue, _internal_instance));
        }
    }

    /**
     * Data/source property setter listeners
     *
     * Each data property whose value affects other properties or the validity of the entity
     * needs to invalidate all previously calculated artifacts. These include:
     *  - any derived properties or constraints that reference the given data property.
     *  - any availability guards (variant expressions) that reference the given data property.
     *  - any style validations, message tokens or guards that reference the given data property.
     *  - the validity of the property (and the containing entity) if the given data property has a length restriction.
     *  - the validity of the property (and the containing entity) if the given data property is required.
     */

    model_internal function setterListenerNext(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerNext);
            }
        }
        _model.invalidateDependentOnNext();
    }

    model_internal function setterListenerPrev(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerPrev);
            }
        }
        _model.invalidateDependentOnPrev();
    }

    model_internal function setterListenerInstance(value:flash.events.Event):void
    {
        _model.invalidateDependentOnInstance();
    }


    /**
     * valid related derived properties
     */
    model_internal var _isValid : Boolean;
    model_internal var _invalidConstraints:Array = new Array();
    model_internal var _validationFailureMessages:Array = new Array();

    /**
     * derived property calculators
     */

    /**
     * isValid calculator
     */
    model_internal function calculateIsValid():Boolean
    {
        var violatedConsts:Array = new Array();
        var validationFailureMessages:Array = new Array();

        var propertyValidity:Boolean = true;
        if (!_model.nextIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_nextValidationFailureMessages);
        }
        if (!_model.prevIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_prevValidationFailureMessages);
        }
        if (!_model.instanceIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_instanceValidationFailureMessages);
        }

        model_internal::_cacheInitialized_isValid = true;
        model_internal::invalidConstraints_der = violatedConsts;
        model_internal::validationFailureMessages_der = validationFailureMessages;
        return violatedConsts.length == 0 && propertyValidity;
    }

    /**
     * derived property setters
     */

    model_internal function set isValid_der(value:Boolean) : void
    {
        var oldValue:Boolean = model_internal::_isValid;
        if (oldValue !== value)
        {
            model_internal::_isValid = value;
            _model.model_internal::fireChangeEvent("isValid", oldValue, model_internal::_isValid);
        }
    }

    /**
     * derived property getters
     */

    [Transient]
    [Bindable(event="propertyChange")]
    public function get _model() : _CollectorEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _CollectorEntityMetadata) : void
    {
        var oldValue : _CollectorEntityMetadata = model_internal::_dminternal_model;
        if (oldValue !== value)
        {
            model_internal::_dminternal_model = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_model", oldValue, model_internal::_dminternal_model));
        }
    }

    /**
     * methods
     */


    /**
     *  services
     */
    private var _managingService:com.adobe.fiber.services.IFiberManagingService;

    public function set managingService(managingService:com.adobe.fiber.services.IFiberManagingService):void
    {
        _managingService = managingService;
    }

    model_internal function set invalidConstraints_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_invalidConstraints;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_invalidConstraints = value;
            _model.model_internal::fireChangeEvent("invalidConstraints", oldValue, model_internal::_invalidConstraints);
        }
    }

    model_internal function set validationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_validationFailureMessages;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_validationFailureMessages = value;
            _model.model_internal::fireChangeEvent("validationFailureMessages", oldValue, model_internal::_validationFailureMessages);
        }
    }

    model_internal var _doValidationCacheOfNext : Array = null;
    model_internal var _doValidationLastValOfNext : ArrayCollection;

    model_internal function _doValidationForNext(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

        if (model_internal::_doValidationCacheOfNext != null && model_internal::_doValidationLastValOfNext == value)
           return model_internal::_doValidationCacheOfNext ;

        _model.model_internal::_nextIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isNextAvailable && _internal_next == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "next is required"));
        }

        model_internal::_doValidationCacheOfNext = validationFailures;
        model_internal::_doValidationLastValOfNext = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfPrev : Array = null;
    model_internal var _doValidationLastValOfPrev : ArrayCollection;

    model_internal function _doValidationForPrev(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

        if (model_internal::_doValidationCacheOfPrev != null && model_internal::_doValidationLastValOfPrev == value)
           return model_internal::_doValidationCacheOfPrev ;

        _model.model_internal::_prevIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isPrevAvailable && _internal_prev == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "prev is required"));
        }

        model_internal::_doValidationCacheOfPrev = validationFailures;
        model_internal::_doValidationLastValOfPrev = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfInstance : Array = null;
    model_internal var _doValidationLastValOfInstance : String;

    model_internal function _doValidationForInstance(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfInstance != null && model_internal::_doValidationLastValOfInstance == value)
           return model_internal::_doValidationCacheOfInstance ;

        _model.model_internal::_instanceIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isInstanceAvailable && _internal_instance == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "instance is required"));
        }

        model_internal::_doValidationCacheOfInstance = validationFailures;
        model_internal::_doValidationLastValOfInstance = value;

        return validationFailures;
    }
    

}

}
