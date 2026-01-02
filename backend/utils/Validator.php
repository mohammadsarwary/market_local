<?php
/**
 * Validator Utility Class
 * 
 * Input validation helper
 */

class Validator {
    private $errors = [];

    /**
     * Validate required field
     * 
     * @param mixed $value
     * @param string $fieldName
     * @return self
     */
    public function required($value, $fieldName) {
        if (empty($value) && $value !== '0' && $value !== 0) {
            $this->errors[$fieldName] = ucfirst($fieldName) . " is required";
        }
        return $this;
    }

    /**
     * Validate email format
     * 
     * @param string $email
     * @param string $fieldName
     * @return self
     */
    public function email($email, $fieldName = 'email') {
        if (!empty($email) && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->errors[$fieldName] = "Invalid email format";
        }
        return $this;
    }

    /**
     * Validate minimum length
     * 
     * @param string $value
     * @param int $min
     * @param string $fieldName
     * @return self
     */
    public function minLength($value, $min, $fieldName) {
        if (!empty($value) && strlen($value) < $min) {
            $this->errors[$fieldName] = ucfirst($fieldName) . " must be at least {$min} characters";
        }
        return $this;
    }

    /**
     * Validate maximum length
     * 
     * @param string $value
     * @param int $max
     * @param string $fieldName
     * @return self
     */
    public function maxLength($value, $max, $fieldName) {
        if (!empty($value) && strlen($value) > $max) {
            $this->errors[$fieldName] = ucfirst($fieldName) . " must not exceed {$max} characters";
        }
        return $this;
    }

    /**
     * Validate numeric value
     * 
     * @param mixed $value
     * @param string $fieldName
     * @return self
     */
    public function numeric($value, $fieldName) {
        if (!empty($value) && !is_numeric($value)) {
            $this->errors[$fieldName] = ucfirst($fieldName) . " must be a number";
        }
        return $this;
    }

    /**
     * Validate minimum value
     * 
     * @param mixed $value
     * @param float $min
     * @param string $fieldName
     * @return self
     */
    public function min($value, $min, $fieldName) {
        if (!empty($value) && $value < $min) {
            $this->errors[$fieldName] = ucfirst($fieldName) . " must be at least {$min}";
        }
        return $this;
    }

    /**
     * Validate phone number format
     * 
     * @param string $phone
     * @param string $fieldName
     * @return self
     */
    public function phone($phone, $fieldName = 'phone') {
        if (!empty($phone) && !preg_match('/^[0-9+\-\s()]+$/', $phone)) {
            $this->errors[$fieldName] = "Invalid phone number format";
        }
        return $this;
    }

    /**
     * Check if validation passed
     * 
     * @return bool
     */
    public function passes() {
        return empty($this->errors);
    }

    /**
     * Check if validation failed
     * 
     * @return bool
     */
    public function fails() {
        return !$this->passes();
    }

    /**
     * Get validation errors
     * 
     * @return array
     */
    public function getErrors() {
        return $this->errors;
    }

    /**
     * Add custom error
     * 
     * @param string $fieldName
     * @param string $message
     * @return self
     */
    public function addError($fieldName, $message) {
        $this->errors[$fieldName] = $message;
        return $this;
    }
}
