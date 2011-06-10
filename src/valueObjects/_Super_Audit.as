/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Audit.as.
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
import mx.events.PropertyChangeEvent;
import mx.validators.ValidationResult;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[Managed]
[ExcludeClass]
public class _Super_Audit extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _AuditEntityMetadata;
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
    private var _internal_backdoor : String;
    private var _internal_time : int;
    private var _internal_desc : String;
    private var _internal__id : String;
    private var _internal_target : String;
    private var _internal_action : String;
    private var _internal_actor : String;
    private var _internal_group : String;
    private var _internal_user : String;
    private var _internal_operation : String;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_Audit()
    {
        _model = new _AuditEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "backdoor", model_internal::setterListenerBackdoor));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "target", model_internal::setterListenerTarget));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "group", model_internal::setterListenerGroup));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "operation", model_internal::setterListenerOperation));

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get backdoor() : String
    {
        return _internal_backdoor;
    }

    [Bindable(event="propertyChange")]
    public function get time() : int
    {
        return _internal_time;
    }

    [Bindable(event="propertyChange")]
    public function get desc() : String
    {
        return _internal_desc;
    }

    [Bindable(event="propertyChange")]
    public function get _id() : String
    {
        return _internal__id;
    }

    [Bindable(event="propertyChange")]
    public function get target() : String
    {
        return _internal_target;
    }

    [Bindable(event="propertyChange")]
    public function get action() : String
    {
        return _internal_action;
    }

    [Bindable(event="propertyChange")]
    public function get actor() : String
    {
        return _internal_actor;
    }

    [Bindable(event="propertyChange")]
    public function get group() : String
    {
        return _internal_group;
    }

    [Bindable(event="propertyChange")]
    public function get user() : String
    {
        return _internal_user;
    }

    [Bindable(event="propertyChange")]
    public function get operation() : String
    {
        return _internal_operation;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set backdoor(value:String) : void
    {
        var oldValue:String = _internal_backdoor;
        if (oldValue !== value)
        {
            _internal_backdoor = value;
        }
    }

    public function set time(value:int) : void
    {
        var oldValue:int = _internal_time;
        if (oldValue !== value)
        {
            _internal_time = value;
        }
    }

    public function set desc(value:String) : void
    {
        var oldValue:String = _internal_desc;
        if (oldValue !== value)
        {
            _internal_desc = value;
        }
    }

    public function set _id(value:String) : void
    {
        var oldValue:String = _internal__id;
        if (oldValue !== value)
        {
            _internal__id = value;
        }
    }

    public function set target(value:String) : void
    {
        var oldValue:String = _internal_target;
        if (oldValue !== value)
        {
            _internal_target = value;
        }
    }

    public function set action(value:String) : void
    {
        var oldValue:String = _internal_action;
        if (oldValue !== value)
        {
            _internal_action = value;
        }
    }

    public function set actor(value:String) : void
    {
        var oldValue:String = _internal_actor;
        if (oldValue !== value)
        {
            _internal_actor = value;
        }
    }

    public function set group(value:String) : void
    {
        var oldValue:String = _internal_group;
        if (oldValue !== value)
        {
            _internal_group = value;
        }
    }

    public function set user(value:String) : void
    {
        var oldValue:String = _internal_user;
        if (oldValue !== value)
        {
            _internal_user = value;
        }
    }

    public function set operation(value:String) : void
    {
        var oldValue:String = _internal_operation;
        if (oldValue !== value)
        {
            _internal_operation = value;
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

    model_internal function setterListenerBackdoor(value:flash.events.Event):void
    {
        _model.invalidateDependentOnBackdoor();
    }

    model_internal function setterListenerTarget(value:flash.events.Event):void
    {
        _model.invalidateDependentOnTarget();
    }

    model_internal function setterListenerGroup(value:flash.events.Event):void
    {
        _model.invalidateDependentOnGroup();
    }

    model_internal function setterListenerOperation(value:flash.events.Event):void
    {
        _model.invalidateDependentOnOperation();
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
        if (!_model.backdoorIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_backdoorValidationFailureMessages);
        }
        if (!_model.targetIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_targetValidationFailureMessages);
        }
        if (!_model.groupIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_groupValidationFailureMessages);
        }
        if (!_model.operationIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_operationValidationFailureMessages);
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
    public function get _model() : _AuditEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _AuditEntityMetadata) : void
    {
        var oldValue : _AuditEntityMetadata = model_internal::_dminternal_model;
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

    model_internal var _doValidationCacheOfBackdoor : Array = null;
    model_internal var _doValidationLastValOfBackdoor : String;

    model_internal function _doValidationForBackdoor(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfBackdoor != null && model_internal::_doValidationLastValOfBackdoor == value)
           return model_internal::_doValidationCacheOfBackdoor ;

        _model.model_internal::_backdoorIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isBackdoorAvailable && _internal_backdoor == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "backdoor is required"));
        }

        model_internal::_doValidationCacheOfBackdoor = validationFailures;
        model_internal::_doValidationLastValOfBackdoor = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfTarget : Array = null;
    model_internal var _doValidationLastValOfTarget : String;

    model_internal function _doValidationForTarget(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfTarget != null && model_internal::_doValidationLastValOfTarget == value)
           return model_internal::_doValidationCacheOfTarget ;

        _model.model_internal::_targetIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isTargetAvailable && _internal_target == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "target is required"));
        }

        model_internal::_doValidationCacheOfTarget = validationFailures;
        model_internal::_doValidationLastValOfTarget = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfGroup : Array = null;
    model_internal var _doValidationLastValOfGroup : String;

    model_internal function _doValidationForGroup(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfGroup != null && model_internal::_doValidationLastValOfGroup == value)
           return model_internal::_doValidationCacheOfGroup ;

        _model.model_internal::_groupIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isGroupAvailable && _internal_group == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "group is required"));
        }

        model_internal::_doValidationCacheOfGroup = validationFailures;
        model_internal::_doValidationLastValOfGroup = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfOperation : Array = null;
    model_internal var _doValidationLastValOfOperation : String;

    model_internal function _doValidationForOperation(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOfOperation != null && model_internal::_doValidationLastValOfOperation == value)
           return model_internal::_doValidationCacheOfOperation ;

        _model.model_internal::_operationIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isOperationAvailable && _internal_operation == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "operation is required"));
        }

        model_internal::_doValidationCacheOfOperation = validationFailures;
        model_internal::_doValidationLastValOfOperation = value;

        return validationFailures;
    }
    

}

}
