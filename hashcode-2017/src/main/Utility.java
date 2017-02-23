package main;
import java.util.Arrays;

public class Utility {
	
	public static void print(int[][] matrix) {
		for (int i = 0; i < matrix.length; i++) {
		    for (int j = 0; j < matrix[i].length; j++) {
		    	if(matrix[i][j] == -1) {
		    		System.out.print("XXXX ");
		    	} else if(matrix[i][j] == 0){
		    		System.out.print("     ");
		    	} else {
		    		System.out.print(String.format("%04d", matrix[i][j]) + " ");
		    	}
		    }
		    System.out.println();
		}
	}
	
	public static int[][] deepCopy(int[][] original) {
	    if (original == null) {
	        return null;
	    }

	    final int[][] result = new int[original.length][];
	    for (int i = 0; i < original.length; i++) {
	        result[i] = Arrays.copyOf(original[i], original[i].length);
	    }
	    return result;
	}

}
