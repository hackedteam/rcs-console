/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - AuditFilters.as.
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
public class _Super_AuditFilters extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _AuditFiltersEntityMetadata;
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
    private var _internal_backdoor : ArrayCollection;
    private var _internal__id : String;
    private var _internal_target : ArrayCollection;
    private var _internal_action : ArrayCollection;
    private var _internal_actor : ArrayCollection;
    private var _internal_group : ArrayCollection;
    private var _internal_user : ArrayCollection;
    private var _internal_operation : ArrayCollection;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_AuditFilters()
    {
        _model = new _AuditFiltersEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "backdoor", model_internal::setterListenerBackdoor));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "_id", model_internal::setterListener_id));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "target", model_internal::setterListenerTarget));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "action", model_internal::setterListenerAction));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "actor", model_internal::setterListenerActor));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "group", model_internal::setterListenerGroup));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "user", model_internal::setterListenerUser));
        model_internal::_changeWatcherArray.push(mx.binding.utils.ChangeWatcher.watch(this, "operation", model_internal::setterListenerOperation));

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get backdoor() : ArrayCollection
    {
        return _internal_backdoor;
    }

    [Bindable(event="propertyChange")]
    public function get _id() : String
    {
        return _internal__id;
    }

    [Bindable(event="propertyChange")]
    public function get target() : ArrayCollection
    {
        return _internal_target;
    }

    [Bindable(event="propertyChange")]
    public function get action() : ArrayCollection
    {
        return _internal_action;
    }

    [Bindable(event="propertyChange")]
    public function get actor() : ArrayCollection
    {
        return _internal_actor;
    }

    [Bindable(event="propertyChange")]
    public function get group() : ArrayCollection
    {
        return _internal_group;
    }

    [Bindable(event="propertyChange")]
    public function get user() : ArrayCollection
    {
        return _internal_user;
    }

    [Bindable(event="propertyChange")]
    public function get operation() : ArrayCollection
    {
        return _internal_operation;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set backdoor(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_backdoor;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_backdoor = value;
            }
            else if (value is Array)
            {
                _internal_backdoor = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_backdoor = null;
            }
            else
            {
                throw new Error("value of backdoor must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "backdoor", oldValue, _internal_backdoor));
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

    public function set target(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_target;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_target = value;
            }
            else if (value is Array)
            {
                _internal_target = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_target = null;
            }
            else
            {
                throw new Error("value of target must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "target", oldValue, _internal_target));
        }
    }

    public function set action(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_action;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_action = value;
            }
            else if (value is Array)
            {
                _internal_action = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_action = null;
            }
            else
            {
                throw new Error("value of action must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "action", oldValue, _internal_action));
        }
    }

    public function set actor(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_actor;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_actor = value;
            }
            else if (value is Array)
            {
                _internal_actor = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_actor = null;
            }
            else
            {
                throw new Error("value of actor must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "actor", oldValue, _internal_actor));
        }
    }

    public function set group(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_group;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_group = value;
            }
            else if (value is Array)
            {
                _internal_group = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_group = null;
            }
            else
            {
                throw new Error("value of group must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "group", oldValue, _internal_group));
        }
    }

    public function set user(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_user;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_user = value;
            }
            else if (value is Array)
            {
                _internal_user = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_user = null;
            }
            else
            {
                throw new Error("value of user must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "user", oldValue, _internal_user));
        }
    }

    public function set operation(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_operation;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_operation = value;
            }
            else if (value is Array)
            {
                _internal_operation = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_operation = null;
            }
            else
            {
                throw new Error("value of operation must be a collection");
            }
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "operation", oldValue, _internal_operation));
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
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerBackdoor);
            }
        }
        _model.invalidateDependentOnBackdoor();
    }

    model_internal function setterListener_id(value:flash.events.Event):void
    {
        _model.invalidateDependentOn_id();
    }

    model_internal function setterListenerTarget(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerTarget);
            }
        }
        _model.invalidateDependentOnTarget();
    }

    model_internal function setterListenerAction(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerAction);
            }
        }
        _model.invalidateDependentOnAction();
    }

    model_internal function setterListenerActor(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerActor);
            }
        }
        _model.invalidateDependentOnActor();
    }

    model_internal function setterListenerGroup(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerGroup);
            }
        }
        _model.invalidateDependentOnGroup();
    }

    model_internal function setterListenerUser(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerUser);
            }
        }
        _model.invalidateDependentOnUser();
    }

    model_internal function setterListenerOperation(value:flash.events.Event):void
    {
        if (value is mx.events.PropertyChangeEvent)
        {
            if (mx.events.PropertyChangeEvent(value).newValue)
            {
                mx.events.PropertyChangeEvent(value).newValue.addEventListener(mx.events.CollectionEvent.COLLECTION_CHANGE, model_internal::setterListenerOperation);
            }
        }
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
        if (!_model._idIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::__idValidationFailureMessages);
        }
        if (!_model.targetIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_targetValidationFailureMessages);
        }
        if (!_model.actionIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_actionValidationFailureMessages);
        }
        if (!_model.actorIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_actorValidationFailureMessages);
        }
        if (!_model.groupIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_groupValidationFailureMessages);
        }
        if (!_model.userIsValid)
        {
            propertyValidity = false;
            com.adobe.fiber.util.FiberUtils.arrayAdd(validationFailureMessages, _model.model_internal::_userValidationFailureMessages);
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
    public function get _model() : _AuditFiltersEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _AuditFiltersEntityMetadata) : void
    {
        var oldValue : _AuditFiltersEntityMetadata = model_internal::_dminternal_model;
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
    model_internal var _doValidationLastValOfBackdoor : ArrayCollection;

    model_internal function _doValidationForBackdoor(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

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
    
    model_internal var _doValidationCacheOf_id : Array = null;
    model_internal var _doValidationLastValOf_id : String;

    model_internal function _doValidationFor_id(valueIn:Object):Array
    {
        var value : String = valueIn as String;

        if (model_internal::_doValidationCacheOf_id != null && model_internal::_doValidationLastValOf_id == value)
           return model_internal::_doValidationCacheOf_id ;

        _model.model_internal::__idIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.is_idAvailable && _internal__id == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "_id is required"));
        }

        model_internal::_doValidationCacheOf_id = validationFailures;
        model_internal::_doValidationLastValOf_id = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfTarget : Array = null;
    model_internal var _doValidationLastValOfTarget : ArrayCollection;

    model_internal function _doValidationForTarget(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

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
    
    model_internal var _doValidationCacheOfAction : Array = null;
    model_internal var _doValidationLastValOfAction : ArrayCollection;

    model_internal function _doValidationForAction(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

        if (model_internal::_doValidationCacheOfAction != null && model_internal::_doValidationLastValOfAction == value)
           return model_internal::_doValidationCacheOfAction ;

        _model.model_internal::_actionIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isActionAvailable && _internal_action == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "action is required"));
        }

        model_internal::_doValidationCacheOfAction = validationFailures;
        model_internal::_doValidationLastValOfAction = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfActor : Array = null;
    model_internal var _doValidationLastValOfActor : ArrayCollection;

    model_internal function _doValidationForActor(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

        if (model_internal::_doValidationCacheOfActor != null && model_internal::_doValidationLastValOfActor == value)
           return model_internal::_doValidationCacheOfActor ;

        _model.model_internal::_actorIsValidCacheInitialized = true;
        var validationFailures:Array = new Array();
        var errorMessage:String;
        var failure:Boolean;

        var valRes:ValidationResult;
        if (_model.isActorAvailable && _internal_actor == null)
        {
            validationFailures.push(new ValidationResult(true, "", "", "actor is required"));
        }

        model_internal::_doValidationCacheOfActor = validationFailures;
        model_internal::_doValidationLastValOfActor = value;

        return validationFailures;
    }
    
    model_internal var _doValidationCacheOfGroup : Array = null;
    model_internal var _doValidationLastValOfGroup : ArrayCollection;

    model_internal function _doValidationForGroup(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

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
    
    model_internal var _doValidationCacheOfUser : Array = null;
    model_internal var _doValidationLastValOfUser : ArrayCollection;

    model_internal function _doValidationForUser(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

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
    
    model_internal var _doValidationCacheOfOperation : Array = null;
    model_internal var _doValidationLastValOfOperation : ArrayCollection;

    model_internal function _doValidationForOperation(valueIn:Object):Array
    {
        var value : ArrayCollection = valueIn as ArrayCollection;

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
