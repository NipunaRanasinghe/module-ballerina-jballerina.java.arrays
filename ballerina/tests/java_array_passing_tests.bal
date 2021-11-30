// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/jballerina.java;
import ballerina/test;

@test:Config {}
isolated function testPassingJavaIntArray() returns error? {
    int[] arrayIntended = [12, 34, 45, 76, 90];
    handle arrayHandle = getPrimitiveIntHandle();
    sortJavaIntArray(arrayHandle);
    any[] value = check fromHandle(arrayHandle, "int");
    int[] array = <int[]> value;
    test:assertEquals(array, arrayIntended);
}

@test:Config {}
isolated function testPassingJavaStringArray() returns error? {
    string[] arrayIntended = ["Five", "Nine", "Seven", "Three", "Two"];
    handle arrayHandle = getStringHandle();
    sortJavaStringArray(arrayHandle);
    any[] value = check fromHandle(arrayHandle, "string");
    string[] array = <string[]> value;
    test:assertEquals(array, arrayIntended);
}

@test:Config {}
isolated function testReturningSortedJavaStringArray() returns error? {
    string[] arrayIntended = ["Ballerina", "Language", "Programming", "Specification"];
    handle receiver = java:fromString("Ballerina Programming Language Specification");
    handle regex = java:fromString(" ");
    handle parts = splitString(receiver, regex);
    sortJavaStringArray(parts);
    any[] value = check fromHandle(parts, "string");
    string[] array = <string[]> value;
    test:assertEquals(array, arrayIntended);
}

@test:Config {}
isolated function testNewJStringArrayInstanceFunction() returns error? {
    string[] arrayIntended = ["Ballerina", "Programming", "Language", "Specification"];
    var jStringClass = java:getClass("java.lang.String");
    if jStringClass is error {
        test:assertFail(msg = jStringClass.message());
    } else {
        handle jStrArray = newInstance(jStringClass, 4);
        set(jStrArray, 0, java:fromString("Ballerina"));
        set(jStrArray, 1, java:fromString("Programming"));
        set(jStrArray, 2, java:fromString("Language"));
        set(jStrArray, 3, java:fromString("Specification"));
        any[] value = check fromHandle(jStrArray, "string");
        string[] array = <string[]> value;
        test:assertEquals(array, arrayIntended);
    }
}

@test:Config {}
isolated function testNewJIntArrayInstanceFunction() returns error? {
    int[] arrayIntended = [10, 100, 1000, 10000];
    var jIntClass = java:getClass("int");
    if jIntClass is error {
        test:assertFail(msg = jIntClass.message());
    } else {
        handle jIntArray = newInstance(jIntClass, 4);
        set(jIntArray, 0, wrapInt(10));
        set(jIntArray, 1, wrapInt(100));
        set(jIntArray, 2, wrapInt(1000));
        set(jIntArray, 3, wrapInt(10000));
        any[] value = check fromHandle(jIntArray, "int");
        int[] array = <int[]> value;
        test:assertEquals(array, arrayIntended);
    }
}

@test:Config {}
isolated function testGetArrayElementMethod() returns error? {
    string[] arrayIntended = ["Ballerina", "Language", "Programming", "Specification"];
    handle array = getSortedJavaStringArray();
    handle elem0 = get(array, 0);
    handle elem1 = get(array, 1);
    handle elem2 = get(array, 2);
    handle elem3 = get(array, 3);
    string s0 = getBStringValueFromHandle(elem0);
    string s1 = getBStringValueFromHandle(elem1);
    string s2 = getBStringValueFromHandle(elem2);
    string s3 = getBStringValueFromHandle(elem3);
    test:assertEquals(s0, arrayIntended[0]);
    test:assertEquals(s1, arrayIntended[1]);
    test:assertEquals(s2, arrayIntended[2]);
    test:assertEquals(s3, arrayIntended[3]);
}

@test:Config {}
isolated function testSetArrayElementMethod() returns error? {
    string[] arrayIntended = ["Bal", "Language", "Programming", "Specification"];
    handle array = getSortedJavaStringArray();
    handle jString = getJStringValue();
    set(array, 0, jString);
    any[] value = check fromHandle(array, "string");
    string[] strArray = <string[]> value;
    test:assertEquals(strArray, arrayIntended);
}

@test:Config {}
isolated function testGetArrayLengthMethod() {
   handle array = getSortedJavaStringArray();
   int length = getLength(array);
   test:assertEquals(length, 4);
}

isolated function getSortedJavaStringArray() returns handle {
    handle receiver = java:fromString("Ballerina Programming Language Specification");
    handle regex = java:fromString(" ");
    handle parts = splitString(receiver, regex);
    sortJavaStringArray(parts);
    return parts;
}


isolated function sortJavaIntArray(handle arrayValue) = @java:Method {
    name:"sort",
    'class: "java.util.Arrays",
    paramTypes:["[I"]
} external;

isolated function sortJavaStringArray(handle arrayValue) = @java:Method {
    name:"sort",
    'class: "java.util.Arrays",
    paramTypes:["[Ljava.lang.String;"]
} external;

isolated function splitString(handle receiver, handle regex) returns handle = @java:Method {
    name:"split",
    'class: "java/lang/String"
} external;

isolated function wrapInt(int i) returns handle = @java:Constructor {
        'class: "java.lang.Integer",
        paramTypes: ["int"]
} external;
