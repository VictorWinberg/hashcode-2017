package main;
import java.io.File;

public class Main {
	
	public static void main(String[] args) {
		new Main().start();
	}
	
	private void start() {
		// Read from input file
		File file = new File("INPUT_FILE");
		Parser parser = new Parser(file);
		parser.readFile();
		
		// Set-up algorithm structure
		Algorithm algorithm = null;
		
		// Perform algorithm
		int times = 1;
		int max = 0;
		
		for (int i = 0; i < times; i++) {
			algorithm.perform();
			int score = ScoreCalculator.getScore(algorithm);
			if (score > max) {
				max = score;
				System.out.print("Got new max: " + max + ", ");
			}
			if (i % 1000 == 0){
				System.out.print("Iteration: " + i + ", ");
			}
		}
		
		// Prints the best output serverhall with servers with min and max values
		System.out.println();
		System.out.println("Max: " + max);
		System.out.println();
	}
}
