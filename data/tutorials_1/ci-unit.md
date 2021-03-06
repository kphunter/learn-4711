#Tutorial ci-unit - Unit Testing Primer
COMP4711 - BCIT - Winter 2018

##Tutorial Goals

Unit testing is a form of functional testing, to prove the correctness
of your model or business logic. Using a test framework, you construct
a set of test cases, each of which exercises a different aspect of
your app's logic, through assertions of correct state after
exercising some functionality.

It is common practice to include this in regression testing, whcih
is a set of tests run against the entire codebase of a project
each time a set of changes is made (a pull request), to make
sure that the new changes didn't break anything that was working
before.

It is also common practice to use unit testing to prove defect
correction. If a bug is reported, write a unit test to reproduce it
(a testcase that purposefully fails). Then fix the bug, ensuring
that the unit tests pass.

This tutorial demonstrates unit testing in a CodeIgniter webapp.

The techniques used are not the only possible way to handle these,
but they are reasonable, and should be familiar to Java programmers.

<div class="alert alert-danger">
Solved the problem with exceptions not being generated - it turns out that
the PHP magic methods are only invoked if a property is not externally
visible. Setting the property scope to "public" kinda hooped that.
Setting the scope to "private" or "protected" will trigger the
PHP magic setter, BUT we then need a magic getter too, inside `Entity`,
shown below.

Sorry for the confusion :'(
</div>

##The Entity class

`application/core/Entity`, with the missing magic getter:

    class Entity extends CI_Model {

        // If this class has a setProp method, use it, else modify the property directly
        public function __set($key, $value) {
            $method = 'set' . str_replace(' ', '', ucwords(str_replace(['-', '_'], ' ', $key)));

            if (method_exists($this, $method))
            {
                $this->$method($value);

                return $this;
            }

            // Otherwise, just set the property value directly.
            $this->$key = $value;

            return $this;
        }

        public function __get($key) {
            return $this->$key;
        }
    }

##Preparation - Composer

This tutorial assumes that you have Composer installed,
and that it is in your PATH.


##Preparation - PHPUnit

PHPUnit 6 is the appropriate version to use with an app using PHP 7.
Its [Getting Started page](https://phpunit.de/getting-started/phpunit-6.html) 
has installation instructions. If you have multiple projects, using different
versions of PHP, then it is better to add PHPUnit as a per-project
dependency using Composer.

The Getting Started page also has a sample class (`Email`) being tested (`EmailTest`).
Use these as an example and guide for your code.

This tutorial also assumes that the webapp you are building is based
off of [CodeIgniter 3.1 Starter4](https://github.com/jedi-academy/CodeIgniter3.1-starter4) 
from the Jedi Academy. That starter project includes useful classes
to base your models on.

Add PHPUnit 6 to your project, per the getting started page.
From the root of your project:

    composer require --dev phpunit/phpunit ^6
    ./vendor/bin/phpunit --version

You should get the following output

    PHPUnit 6.5.7 by Sebastian Bergmann and contributors.

You probably want to "git ignore" `vendor/` and `composer.lock` in your project, to keep your repo clean.

##Our Models

We have two models: `application/models/Fruitbowl` is meant to be a collection
of `application/model/Fruit` objects.

Using the base models from the starter, our collection can be as simple as

    class Fruitbowl extends Memory_Model {
    }

NOTE that I am just extending `Memory_Model`, whereas you would extend the model
appropriate to the kind of persistence you plan to use.

Our basic entity model could be

    class Fruit extends Entity {
	public $id;
	public $name;
	public $color;
	public $weight;
	public $picker;
    }

Normally, we would expect that the `Fruitbowl` would hold a collection of
`Fruit` objects, but the base model provided in the starter does not
afford that capability - it just holds standard PHP objects.

##Business Logic

Unit testing needs business logic to test.

Let's add a rule to our collection, to the effect that a fruit bowl can have no
more than six items in it. This would be appropriate to enforce in the collection's
`add` method. We could ignore any attempts to add more fruit if the bowl were full,
or we could through an exception and force the calling code to deal with the problem.
The latter approach is better.

Our collection class, enhanced:

    class Fruitbowl extends Memory_Model {
        // over-ride base collection adding, with a limit
        function add($record) {
            if ($this->size() >= 6)
                throw new Exception('The fruit bowl is full');
        }
    }

Yes, the code has bad smells - a hard-coded limit, no directives indicating
the exception that might be thrown. Too bad - this is an example, not a book.

With our entity model class extending `Entity`, we only need to provide
the setter methods that enforce a business rule for an entity property.

In the example `Fruit`, that might include everything except for the `picker` property,
which we don't care about.
Here is an enhanced version of our entity class, with some arbitrary rules:

    public class Fruit extends Entity {
	protected $id;
	protected $name;
	protected $color;
	protected $weight;
	protected $picker;

    // insist that an ID be present
    public function setId($value) {
	if (empty($value))
	    throw new InvalidArgumentException('An Id must have a value');
	$this->id = $value;
	return $this;
    }

    // insist that a Name be present and no longer than 30 characters
    public function setName($value) {
	if (empty($value))
	    throw new Exception('A Name cannot be empty');
	if (strlen($value) > 30)
	    throw new Exception('A Name cannot be longer than 30 characters');
	$this->name = $value;
	return $this;
    }

    // insist that a Color be one of yellow, red or green
    public function setColor($value) {
	$allowed = ['yellow', 'red', 'green'];
	if (!in_array($value, $allowed))
	    throw new Exception('A color must be one we like');
	$this->color = $value;
	return $this;
    }

    // insist that a Weight be a positive number, and less than 1000 (grams)
    public function setWeight($value) {
	if (!is_numeric($value))
	    throw new Exception('Weight must be numeric');
	if ($value > 1000)
	    throw new Exception('A fruit cannot weigh more than 1kg');
	$this->weight = $value;
	return $this;
    }

    }

##Testing prep

Make a tests folder in your project root, at the same level as `application`
and `public`. Inside it, create the subfolder `application/models`, to hold
the test cases we will use for unit testing.

Make sure you have copied `public/index.php` to `tests/Bootstrap.php`.

Add a [PHPUnit configuration file](https://phpunit.de/manual/6.5/en/appendixes.configuration.html) 
to your project root, `phpunit.xml`.
Here's a sample, with a number of options pre-set.

    <?xml version="1.0" encoding="UTF-8"?>
    <phpunit bootstrap="tests/Bootstrap.php"
            backupGlobals="false"
            colors="true"
            convertErrorsToExceptions="true"
            convertNoticesToExceptions="true"
            convertWarningsToExceptions="true"
            stopOnError="false"
            stopOnFailure="false"
            stopOnIncomplete="false"
            stopOnSkipped="false">
        <testsuites>
            <testsuite name="My Test Suite">
                <directory>./tests/application</directory>
            </testsuite>
        </testsuites>
    </phpunit>

Try it, from your project root:

    ./vendor/bin/phpunit

resulting in something like

    PHPUnit 6.5.7 by Sebastian Bergmann and contributors.
    Time: 27 ms, Memory: 4.00MB
    No tests executed!

There is some HTML shown before the test results - the output
from the default controller. A proper approach would use
the CI unit test support classes to avoid this, but
we don't want to worry about that for this lab :(

##Test the collection

Following the lead of the getting started page, we can get down to business, with
`tests/application/models/FruitbowlTest`.

    <?php
    use PHPUnit\Framework\TestCase;

    class FruitbowlTest  extends TestCase {
    }

Let's create a sample Fruitbowl object to test with:

    function setUp() {
        $this->CI = &get_instance();
        $this->CI->load->model('fruitbowl');
        $this->CI->load->model('fruit');
        $this->bowl = new Fruitbowl();
    }

We only have the one thing to test, adding, so let's add a test to do that

	function testSizeLimit()
	{
		// add 6 fruits
		for ($i = 1; $i < 7; $i ++ )
		{
			$fruit = new Fruit();
			$fruit->id = $i;
			$this->bowl->add($fruit);
		}
		// make sure we're there
		$this->assertEquals(6,$this->bowl->size());
		// make sure we can't add a 7th
		$fruit = new Fruit();
		$fruit->id = 7;
		$this->expectException(Exception::class);
		$this->bowl->add($fruit);
	}

If an exception isn't thrown when we try to add the 7th fruit, that will be treated
as a unit test failure.

Run your unit tests, and you should see...

    PHPUnit 6.5.7 by Sebastian Bergmann and contributors.

    F                                                                   1 / 1 (100%)

    Time: 44 ms, Memory: 6.00MB

    There was 1 failure:

    1) FruitbowlTest::testSizeLimit
    Failed asserting that 0 matches expected 6.

    /pub7/htdocs/starter-todo5/tests/application/models/FruitbowlTest.php:26
    /pub7/htdocs/starter-todo5/vendor/phpunit/phpunit/phpunit:53

    FAILURES!
    Tests: 1, Assertions: 1, Failures: 1.

Oops - something needs fixing ... we're not adding to the collection!

##Test the Entity

Test the `Fruit` class with `tests/application/models/FruitTest`:

    <?php

    use PHPUnit\Framework\TestCase;

    class FruitTest extends TestCase
    {

            function setUp()
            {
                    $this->CI = &get_instance();
                    $this->CI->load->model('fruit');
                    $this->item = new Fruit();
                    $this->item->id = 1;
                    $this->item->name = 'Banana';
                    $this->item->color = 'yellow';
                    $this->item->weight = 100;
            }

    }

We need to add tests to enforce the same validation rules that
form validation does, and perhaps then some.
Why do we need this in addition to form validation? because data
might come from different sources, and not just through the app's
front-end.

Add a separate method for each test done. For instance, that a property
is present, and that it has a maximum length, it would be better
to make a separate method for each, to prove that your rule
enforcement is working as expected. If you combine those in one
method, and the first test fails, then the second test won't be attempted.

Here are some test methods that could be added:

        function testSetup() {
            $this->assertEquals(1, $this->item->id);
            $this->assertEquals('Banana', $this->item->name);
            $this->assertEquals('yellow', $this->item->color);
            $this->assertEquals(100, $this->item->weight);
        }

        function testValidId() {
            $expected = 123;
            $this->item->id = $expected;
            $this->assertEquals($expected, $this->item->id);
        }

        /**
         * This is an alternate way to assert that an exception should occur
         * @expectedException InvalidArgumentException
         */
        function testInvalidId() {
    //	$this->expectException('InvalidArgumentException');
            $this->item->id = null;
        }

        function testNamePresent() {
            $expected = "George";
            $this->item->name = $expected;
            $this->assertEquals($expected, $this->item->name);
        }

        function testNameAbsent() {
            $badvalue = "";
            $this->expectException(Exception::class);
            $this->item->name = $badvalue; // this should croak
        }

        function testNameTooLong() {
            $badvalue = "George Paul John Ringo Henry Tom Dick";
            $this->expectException('Exception');
            $this->item->name = $badvalue; // this should croak
        }



Testing notes:

- the tests shown are just one way to test, and not necessarily the best or the most
comprehensive way to test.
- we test the `picker` property, for completeness; we don't expect a failure,
but definitely want to know if the code blows up!

Run the unit tests, and we should see...

    ...
    FAILURES!
    Tests: 6, Assertions: 6, Failures: 5.

Hmm - we shouldn't see this! I have a bug in my tests to fix!!

##Code Coverage

**Note**: I forgot about this after I was feeling somewhat better :-/
Fixed now!

Code coverage gives us assurance that all the source code is being exercised 
as part of unit testing. "Git ignore" the `tests/coverage` 
folder, to keep the repo clean.

You need to make sure that xdebug is installed for your PHP.

Apart from that, we need a `whitelist` element in our `phpunit.xml`,
to specify which parts of our app we want code coverage for.

We trigger code coverage with a `logging` element, providing for
logging code coverage data and then generating the report(s).

All will end up inside the `tests/coverage` folder, which I suggested
git ignoring above, so you don't inflict this on your teamnmates.

The resulting `phpunit.xml` would look like...

    <?xml version="1.0" encoding="UTF-8"?>
    <phpunit bootstrap="tests/Bootstrap.php"
             backupGlobals="false"
             colors="true"
             convertErrorsToExceptions="true"
             convertNoticesToExceptions="true"
             convertWarningsToExceptions="true"
             stopOnError="false"
             stopOnFailure="false"
             stopOnIncomplete="false"
             stopOnSkipped="false"
    >
        <testsuites>
            <testsuite name="My Test Suite">
                <directory>./tests/application</directory>
            </testsuite>
        </testsuites>
        <filter>
            <whitelist processUncoveredFilesFromWhitelist="true">
                <directory suffix=".php">application/models</directory>
            </whitelist>
        </filter>
        <logging>
            <log type="coverage-clover" target="tests/coverage/clover.xml"/>
            <log type="coverage-html" target="tests/coverage/report" lowUpperBound="35" highLowerBound="70"/>
             <log type="coverage-text" target="tests/coverage/coverage.txt" showUncoveredFiles="false"/>
        </logging>
    </phpunit>

Code coverage will be determined every time you unit test. Try it out! 
You should see results along the lines of ...

    PHPUnit 6.1.3 by Sebastian Bergmann and contributors.

    ....................                                              20 / 20 (100%)

    Time: 222 ms, Memory: 12.00MB

    OK (20 tests, 27 assertions)

    Generating code coverage report in Clover XML format ... done

    Generating code coverage report in HTML format ... done

