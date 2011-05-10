/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - SessionObject.as.
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
import valueObjects.User;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[ExcludeClass]
public class _Super_SessionObject extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
        valueObjects.User.initRemoteClassAliasSingleChild();
    }

    model_internal var _dminternal_model : _SessionObjectEntityMetadata;
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
    private var _internal_cookie : String;
    private var _internal_time : String;
    private var _internal_level : ArrayCollection;
    private var _internal_user : valueObjects.User;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_SessionObject()
    {
        _model = new _SessionObjectEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "cookie", model_internal::setterListenerCookie));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "time", model_internal::setterListenerTime));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "level", model_internal::setterListenerLevel));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "user", model_internal::setterListenerUser));

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get cookie() : String
    {
        return _internal_cookie;
    }

    [Bindable(event="propertyChange")]
    public function get time() : String
    {
        return _internal_time;
    }

    [Bindable(event="propertyChange")]
    public function get level() : ArrayCollection
    {
        return _internal_level;
    }

    [Bindable(event="propertyChange")]
    public function get user() : valueObjects.User
    {
        return _internal_user;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set cookie(value:String) : void
    {
        var oldValue:String = _internal_cookie;
        if (oldValue !== value)
        {
            _internal_cookie = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "cookie", oldValue, _internal_cookie));
        }
    }

    public function set time(value:String) : void
    {
        var oldValue:String = _internal_time;
        if (oldValue !== value)
        {
            _internal_time = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "time", oldValue, _internal_time));
        }
    }

    public function set level(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_level;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_level = value;
            }
            else if (value is Array)
            {
                _internal_level = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_level = null;
            }
            else
            {
                throw new Error("value of level must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "level", oldValue, _internal_level));
        }
    }

    public function set user(value:valueObjects.User) : void
    {
        var oldValue:valueObjects.User = _internal_user;
        if (oldValue !== value)
        {
            _internal_user = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "user", oldValue, _internal_user));
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

    model_internal function setterListenerCookie(value:flash.events.Event):void
    {
        _model.invalidateDependentOnCookie();
    }

    model_internal function setterListenerTime(value:flash.events.Event):void
    {
        _model.invalidateDependentOnTime();
    }

    model_internal function setterListenerLevel(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerLevel);
            }
        }
        _model.invalidateDependentOnLevel();
    }

    model_internal function setterListenerUser(value:flash.events.Event):void
    {
        _model.invalidateDependentOnUser();
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
        if (!_model.cookieIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_cookieValidationFailureMessages);
        }
        if (!_model.timeIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_timeValidationFailureMessages);
        }
        if (!_model.levelIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_levelValidationFailureMessages);
        }
        if (!_model.userIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_userValidationFailureMessages);
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
    public function get _model() : _SessionObjectEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _SessionObjectEntityMetadata) : void
    {
        var oldValue : _SessionObjectEntityMetadata = model_internal::_dminternal_model;
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

    model_internal var _doValidationCacheOfCookie : Array = null;
    model_internal var _doValidationLastValOfCookie : String;

    model_internal function _doValidationForCookie(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfCookie != null && model_internal::_doValidationLastValOfCookie == value)
           return model_internal::_doValidationCacheOfCookie ;

        _model.model_internal::_cookieIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isCookieAvailable && _internal_cookie == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "cookie is required"));
        }

        model_internal::_doValidationCacheOfCookie = validationFailures;
        model_internal::_doValidationLastValOfCookie = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfTime : Array = null;
    model_internal var _doValidationLastValOfTime : String;

    model_internal function _doValidationForTime(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfTime != null && model_internal::_doValidationLastValOfTime == value)
           return model_internal::_doValidationCacheOfTime ;

        _model.model_internal::_timeIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isTimeAvailable && _internal_time == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "time is required"));
        }

        model_internal::_doValidationCacheOfTime = validationFailures;
        model_internal::_doValidationLastValOfTime = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfLevel : Array = null;
    model_internal var _doValidationLastValOfLevel : ArrayCollection;

    model_internal function _doValidationForLevel(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

        if (model_internal::_doValidationCacheOfLevel != null && model_internal::_doValidationLastValOfLevel == value)
           return model_internal::_doValidationCacheOfLevel ;

        _model.model_internal::_levelIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isLevelAvailable && _internal_level == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "level is required"));
        }

        model_internal::_doValidationCacheOfLevel = validationFailures;
        model_internal::_doValidationLastValOfLevel = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfUser : Array = null;
    model_internal var _doValidationLastValOfUser : valueObjects.User;

    model_internal function _doValidationForUser(valueIn:Object):Array
    {
        var value : valueObjects.User = valueIn as valueObjects.User;

        if (model_internal::_doValidationCacheOfUser != null && model_internal::_doValidationLastValOfUser == value)
           return model_internal::_doValidationCacheOfUser ;

        _model.model_internal::_userIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isUserAvailable && _internal_user == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "user is required"));
        }

        model_internal::_doValidationCacheOfUser = validationFailures;
        model_internal::_doValidationLastValOfUser = value;

        return validationFailures;
    }
    

}

}
