@isTest
public class MyIterableTest {

    // Test method to check the behavior of the MyIterable class
    @isTest
    static void testIterableForLoop() {
        // Step 1: Create a list of strings
        List<String> strings = new List<String>{'Hello', 'World'};

        // Step 2: Create an instance of MyIterable with the list of strings
        MyIterable myIterableInstance = new MyIterable(strings);
         System.debug('Running the for Loop...');
        // Step 3: Use a for loop to iterate over the MyIterable instance
        for (String str : myIterableInstance) {
            // Step 4: Print each string using System.debug
            System.debug('String:'+str);
        }
    }
}