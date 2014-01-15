package com.example.subnetting;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.view.Menu;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.TextView;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.*;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

import org.apache.http.conn.util.InetAddressUtils;

import com.example.subnetting.R.string;

public class MainActivity extends Activity {

	public void ip1(View x) {
		EditText editText = (EditText)findViewById(R.id.ip1);
		editText.setText("",TextView.BufferType.EDITABLE); } 
		
	public void ip2(View x) {
		EditText editText = (EditText)findViewById(R.id.ip2);
		editText.setText("",TextView.BufferType.EDITABLE); } 
			
	public void ip3(View x) {
		EditText editText = (EditText)findViewById(R.id.ip3);
		editText.setText("",TextView.BufferType.EDITABLE); }
				
	public void ip4(View x) {
		EditText editText = (EditText)findViewById(R.id.ip4);
		editText.setText("",TextView.BufferType.EDITABLE); } 
	
	public void n1(View x) {
		  EditText editText = (EditText)findViewById(R.id.n1);
		  editText.setText("",TextView.BufferType.EDITABLE); }
		  
	public void n2(View x) {
	   	EditText editText = (EditText)findViewById(R.id.n2);
	    editText.setText("",TextView.BufferType.EDITABLE); } 
		 
    public void n3(View x) {
		 EditText editText = (EditText)findViewById(R.id.n3);
		 editText.setText("",TextView.BufferType.EDITABLE);  }
		 
	public void n4(View x) {
		 EditText editText = (EditText)findViewById(R.id.n4);
		 editText.setText("",TextView.BufferType.EDITABLE); } 	
	
	public static void setSentence()
	{
	}
	 
	public static String clean(String strOctet)
	{
		String[] arrOctet = strOctet.split("");
		List<String> listOctet = new LinkedList<String>(Arrays.asList(arrOctet));
		
		System.out.println("here: " + strOctet + ";size: " + listOctet.size());
		if(listOctet.size() > 2)
		{
			System.out.println("Got here");
			for(int i=1; i<listOctet.size(); i++)
			{
				if(listOctet.get(1).equals("0"))
					listOctet.remove(1);
				else
					break;
			}
			strOctet = "";
			for(int i=0; i<listOctet.size(); i++)
			{
				strOctet = strOctet + listOctet.get(i);
			}
		}
		System.out.println("here2: " + strOctet);

		return strOctet;
	}
	
	public static boolean validIP (String ip) {
	    try {
	        if (ip == null) {
	            return false;
	        }

	        String[] parts = ip.split( "\\." );
	        if ( parts.length != 4 ) {
	            return false;
	        }
	        
	        if(parts[0].equals("0"))
	        	return false;

	        for ( String s : parts ) {
	            int i = Integer.parseInt( s );
	            if ( (i < 0) || (i > 255) ) {
	                return false;
	            }
	        }

	        return true;
	    } catch (NumberFormatException nfe) {
	        return false;
	    }
	} 
	
	public static boolean validNetmask(String[] sepparateBitsNetmask)
	{
		int bFoundZero = 0;
		if(sepparateBitsNetmask.length != 33)
			return false;
		for(int i=1; i<sepparateBitsNetmask.length; i++)
		{
			if(sepparateBitsNetmask[i].equals("0"))
				bFoundZero = 1;
			if(bFoundZero == 1 && sepparateBitsNetmask[i].equals("1"))
				return false;
		}
		
		return true;
	}
	
	public static int getSlash(String[] sepparateBitsNetmask)
	{
		int count = 0;
		for(int i=1; i<sepparateBitsNetmask.length; i++)
		{
			if(sepparateBitsNetmask[i].equals("1"))
				count++;
		}
		return count;
	}
	
	public static int getNoOfHosts(String[] sepparateBitsNetmask)
	{
		int nSlash = getSlash(sepparateBitsNetmask);
		int nSlashWildcard = 32 - nSlash;
		return (int) Math.pow(2, nSlashWildcard) - 2;
	}
	
	public static String getBroadcast(String[] arrBitsNetmask, String[] arrBitsIP)
	{

		int nSlash = getSlash(arrBitsNetmask);
		
		System.out.print("IP Broadcast2: ");
		for(int i=0; i<arrBitsIP.length; i++)
		{
			System.out.print(arrBitsIP[i]);
		}
		System.out.println();
		
		for(int i=nSlash+1; i<arrBitsNetmask.length; i++)
			arrBitsIP[i] = "1";
		
		String strBitsIP = "";
		for(int i=1; i<arrBitsIP.length; i++)
		{
			strBitsIP = strBitsIP + arrBitsIP[i];
		}
			
		int strIPoctet1 = Integer.parseInt(strBitsIP.substring(0, 8), 2);		
		int strIPoctet2 = Integer.parseInt(strBitsIP.substring(8, 16), 2);		
		int strIPoctet3 = Integer.parseInt(strBitsIP.substring(16, 24), 2);		
		int strIPoctet4 = Integer.parseInt(strBitsIP.substring(24, 32), 2);		
		
		String strBroadcast = strIPoctet1 + "." + strIPoctet2 + "." + strIPoctet3 + "." + strIPoctet4;
		
		return strBroadcast;
	}
	
	public static String getNetwork(String[] arrBitsNetmask, String[] arrBitsIP)
	{
		int nSlash = getSlash(arrBitsNetmask);
		
		for(int i=nSlash+1; i<arrBitsNetmask.length; i++)
			arrBitsIP[i] = "0";
		
		String strBitsIP = "";
		for(int i=1; i<arrBitsIP.length; i++)
		{
			strBitsIP = strBitsIP + arrBitsIP[i];
		}
			
		int strIPoctet1 = Integer.parseInt(strBitsIP.substring(0, 8), 2);		
		int strIPoctet2 = Integer.parseInt(strBitsIP.substring(8, 16), 2);		
		int strIPoctet3 = Integer.parseInt(strBitsIP.substring(16, 24), 2);		
		int strIPoctet4 = Integer.parseInt(strBitsIP.substring(24, 32), 2);		
		
		String strNetwork = strIPoctet1 + "." + strIPoctet2 + "." + strIPoctet3 + "." + strIPoctet4;
		
		return strNetwork;
	}
	 
	public String doIPClass(String strFirstOctet)
	{
		int nFirstOctet = Integer.parseInt(strFirstOctet);
		if(nFirstOctet <= 127)
		{
			RadioButton radioA = (RadioButton)findViewById(R.id.radio_button_a);
			radioA.setChecked(true);
			return "A";
		}
		else if(128 <= nFirstOctet && nFirstOctet <= 191)
		{
			RadioButton radioB = (RadioButton)findViewById(R.id.radio_button_b);
			radioB.setChecked(true);
			return "B";
		}
		else if(192 <= nFirstOctet && nFirstOctet <= 223)
		{
			RadioButton radioC = (RadioButton)findViewById(R.id.radio_button_c);
			radioC.setChecked(true);
			return "C";
		}
		
		return null;
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
	}
	
	@Override
	protected void onStart() {
		super.onStart();
		setContentView(R.layout.activity_main);
		        
        Button buttonCalculate = (Button) findViewById(R.id.button_calculate);
        
        buttonCalculate.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {

				InputMethodManager inputManager = (InputMethodManager)
                        getSystemService(Context.INPUT_METHOD_SERVICE); 

				inputManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(),
                           InputMethodManager.HIDE_NOT_ALWAYS);
				
				String ip1 = ((EditText)findViewById(R.id.ip1)).getText().toString();
				ip1 = clean(ip1);
				String ip2 = ((EditText)findViewById(R.id.ip2)).getText().toString();
				ip2 = clean(ip2);
				String ip3 = ((EditText)findViewById(R.id.ip3)).getText().toString();
				ip3 = clean(ip3);
				String ip4 = ((EditText)findViewById(R.id.ip4)).getText().toString();
				ip4 = clean(ip4);
				
				String n1 = ((EditText)findViewById(R.id.n1)).getText().toString();
				n1 = clean(n1);
				String n2 = ((EditText)findViewById(R.id.n2)).getText().toString();
				n2 = clean(n2);
				String n3 = ((EditText)findViewById(R.id.n3)).getText().toString();
				n3 = clean(n3);
				String n4 = ((EditText)findViewById(R.id.n4)).getText().toString();
				n4 = clean(n4);


				String completeIP = ip1 + "." + ip2 + "." + ip3 + "." + ip4;
				String completeNetmask = n1 + "." + n2 + "." + n3 + "." + n4;

				if(validIP(completeIP) == true && validIP(completeNetmask) == true)
					try 
					{
						InetAddress addr = InetAddress.getByName(completeIP);
						InetAddress netmask = InetAddress.getByName(completeNetmask);
	
						byte[] byteIP = addr.getAddress();
						byte[] byteNetmask = netmask.getAddress();
						
						String stringBitsIP = new BigInteger(1, byteIP).toString(2);
						String stringBitsNetmask = new BigInteger(1, byteNetmask).toString(2);						
						
						//if the string of bits starts with 1, but the length is <32, complete in front with 0
						if(stringBitsIP.length() < 32)
						{
							for(int i=0; i<32-stringBitsIP.length(); i++)
							{
								stringBitsIP = "0" + stringBitsIP;
							}
						}
												
						String[] arrBitsIP = stringBitsIP.split("");
						System.out.println(arrBitsIP.length);
						String[] arrBitsNetmask = stringBitsNetmask.split("");
				
						System.out.println("\nIP: " + stringBitsIP);
						System.out.println("\nNetmask: " + stringBitsNetmask);

						
						if(validNetmask(arrBitsNetmask) == false)
							showDialogueIncompleteData().show();
						else
						{							
							int nNoOfHosts = getNoOfHosts(arrBitsNetmask);
							int nSlash = getSlash(arrBitsNetmask);
							System.out.println("Broadcast0: " + stringBitsIP);
							String strBroadcast = getBroadcast(arrBitsNetmask, arrBitsIP);
							String strNetwork = getNetwork(arrBitsNetmask, arrBitsIP);
							String strNetworkClass = doIPClass(ip1);
							
							EditText editTextBroadcast = (EditText) findViewById(R.id.edit_text_broadcast_address);
							editTextBroadcast.setText(strBroadcast);
							
							EditText editTextNetwork = (EditText) findViewById(R.id.edit_text_network_address);
							editTextNetwork.setText(strNetwork);
							
							EditText editTextNoOfHosts = (EditText) findViewById(R.id.edit_text_number_of_hosts);
							editTextNoOfHosts.setText(nNoOfHosts + " hosts");
							
							EditText editTextNetmaskSlash = (EditText) findViewById(R.id.edit_text_netmask_slash);
							editTextNetmaskSlash.setText("/" + nSlash);
							
							String strSentence = getResources().getString(R.string.sentence);
							String[] arrSentence = strSentence.split("#");
							strSentence = arrSentence[0] + strNetwork + 
										arrSentence[1] + strNetworkClass + 
										arrSentence[2] + nNoOfHosts + 
										arrSentence[3] + strBroadcast +
										arrSentence[4] + nSlash +
										arrSentence[5];							
							TextView textViewSentene = (TextView) findViewById(R.id.text_view_sentence);
							textViewSentene.setText(strSentence);
						}
						
					} 
					catch (UnknownHostException e) 
					{
						showDialogueIncompleteData().show();
					}
				else
					showDialogueIncompleteData().show();

			}
		});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	private Dialog showDialogueIncompleteData() {
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		LayoutInflater inflater = this.getLayoutInflater();
		
		EditText editTextBroadcast = (EditText) findViewById(R.id.edit_text_broadcast_address);
		editTextBroadcast.setText("");
		
		EditText editTextNetwork = (EditText) findViewById(R.id.edit_text_network_address);
		editTextNetwork.setText("");
		
		EditText editTextNoOfHosts = (EditText) findViewById(R.id.edit_text_number_of_hosts);
		editTextNoOfHosts.setText("");
		
		EditText editTextNetmaskSlash = (EditText) findViewById(R.id.edit_text_netmask_slash);
		editTextNetmaskSlash.setText("");
		
		TextView textViewSentene = (TextView) findViewById(R.id.text_view_sentence);
		textViewSentene.setText("");
		
		RadioButton radioA = (RadioButton)findViewById(R.id.radio_button_a);
		radioA.setChecked(false);
		
		RadioButton radioB = (RadioButton)findViewById(R.id.radio_button_b);
		radioB.setChecked(false);
		
		RadioButton radioC = (RadioButton)findViewById(R.id.radio_button_c);
		radioC.setChecked(false);
		
		builder.setView(inflater.inflate(R.layout.incomplete_data, null))
	    	.setCancelable(true)
	    	.setPositiveButton("OK", null);
		return builder.create();
	}


}
