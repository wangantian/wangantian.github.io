---
title: "ECE 2090 Logic and Computing Devices Laboratory (2023 Fall, 2023 Spring, 2022 Fall)"
collection: teaching
type: "Undergraduate lab"
permalink: /teaching/Clemson_ECE2090
venue: "Clemson University, Holcombe Department of Electrical and Computer Engineering"
date: 2023-08-16
location: "Clemson, SC, USA"
---

Introduction to designing, building, simulating and testing digital logic circuits. Topics include SSI and MSI ICs; general combinational circuits; adders, decoders and multiplexors; general sequential circuits; shift registers, counters and memory.

<h2>Lab course background</h2>

This lab is accompany with ECE 2010 Logic and Computing Devices at Clemson University. Students are expected to perform circuit board building using 74-series chips and gate level logic simulation using Logisim Evolution, with lab related simulation detials listed in [Logisim Evolution tutorial](#Logisim_Evolution_Tutorial). 

Though the lab content is simple, while all these labs introduce concepts that with broad significance for students' future learning. It is summarized in [Extra materials for students' interests](#Extra_material).

This lab course uses Final/Capstone project as final evaluation. Students are expected to design a larger scale digital design to fulfill the course requirements. Students were provided with possible final project topics listed in [Lab final project prompts](#project_prompts), but they are free to choose their topics based on their interest. 

<h2 id="Logisim_Evolution_Tutorial">Logisim Evolution tutorial</h2>
<h3>Download address</h3>
Logisim Evoluion is convinently avaliable from website [https://github.com/logisim-evolution/logisim-evolution](https://github.com/logisim-evolution/logisim-evolution)

Download the package as listed for different operation systems:
Windows user, please use logisim-evolution-<version>.msi
Mac user, please use logisim-evolution-<version>.dmg
Linux user, please use logisim-evolution-<version>-1.x86_64.rpm.

Note that there may be an issue with logisim evolution, making some download files to .circ extension. You can fix it using the method here. 

[https://github.com/logisim-evolution/logisim-evolution/issues/1471#issuecomment-1332917265](https://github.com/logisim-evolution/logisim-evolution/issues/1471#issuecomment-1332917265)

"Removing the registry key HKEY_CLASSES_ROOT\MIME\Database\Content Type\application/octet-stream\Extension instantly resolves the issue."

<h3>Basic usage tutorial</h3>
The draft of the basic usage is avalible here <embed src="https://wangantian.github.io/files/Teaching_Clemson/LogisimEvollution_Tutorial.pdf" width="100%" height="50px"/> 

<h2 id="Extra_material">Extra materials for students' interests</h2>
There are 10 lab sessions of this lab courses, below is the collected extra materials that related to the corresponding lab content. 
<h3> Lab 01 Introduction </h3>
<h3> Lab 02 Introduction </h3>
<h3> Lab 03 Introduction </h3>
<h3> Lab 04 Introduction </h3>
<h3> Lab 05 Introduction </h3>
<h3> Lab 06 Introduction </h3>
<h3> Lab 07 Introduction </h3>
<h3> Lab 08 Introduction </h3>
<h3> Lab 09 Introduction </h3>
<h3> Lab 10 Introduction </h3>


<h2 id="project_prompts">Lab final project possible topics</h2>
This list was last updated by the end of Fall 2023.
<h3> Final project objectives</h3>
This open-ended project involving design, simulation, and analysis of a digital circuit related to a concept of students' choice. Students are tasked with thoroughly exploring all available components within the simulation software. Additionally, students are encouraged to consider integrating this project into their future endeavors across various courses.

<h3> Final project components for simulation</h3>

<div markdown="1">
<aside> 
<li>Gate-level design
<ul>
	<li>Basic gates(like AND/OR/NOT/XOR/XNOR/)</li>
	<li>74 series IC(as provided in the lab kit)</li>
	<li>Memory (RAM/ROM/shift register)</li>
	<li>Display/interactive purpose components</li>
	<li>Seven-segment/Hex display/Color LED/ LED Matrix</li>
	<li>MUX/DeMUX</li>
</ul>

<p><a href="#calculator">Calculator with display in decimal.</a></p>
<p><a href="#traffic">Traffic light</a></p>
<p><a href="#pill">Pill separator, &gt;=2 types of pill&nbsp;</a></p>
<p><a href="#x_o">X and O game</a></p>
<p><a href="#lock">Digital Lock</a></p>
<p><a href="#english_display">LED display control for multiple combinations of English character(s)</a></p>
<p><a href="#scoreboard">Different kinds of scoreboards&amp;Billboard</a></p>
<p><a href="#clocks">Clock/timer/meters/alarm clock with functions</a></p>
<p><a href="#vending">Vending machine simulation</a></p>
<p><a href="#elevator">Elevator simulation</a></p>
<p><a href="#ic_testor">Digital circuit functionality checker for multiple(&gt;=4 kinds of &gt;=4 input pins meaning full digital circuit)</a></p>
<p><a href="#seq_gen">Sequence Generator(Fibonacci) with display</a></p>
<p><a href="#stream_enc_dec">Streaming channel encoder/decoder using simple Parity error correction code.</a></p>
<p><a href="#mem_test">Memory&nbsp; tester</a></p>
<p><a href="#buzzer">Quiz buzzer designr</a></p>
<p><a href="#alu">Simple ALU/processor design (may refer to CS61C from UC Berkeley)&nbsp;</a></p>
<p><a href="#other">Other related online resources.</a></p>
<ul>
    <li><span><span><a id="calculator"></a>Calculator with display in decimal.</span></span>
        <ul>
            <li><span>Addition/Subtraction/Multiplication/Division</span></li>
            <li><span>Fixed-point decimal operation.</span></li>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="traffic"></a>Traffic light</span>
        <ul>
            <li>Use integrated counter or memory to design the traffic light.
                <ul>
                    <li>Left turn/pedestrian signal/sensor-based signal.&nbsp;</li>
                    <li>Configurability of the different traffic phase-switching patterns (peak hour/night hour).</li>
                    <li>Countdown clock for red &amp; green light.</li>
                    <li>Low traffic blinking light(blinking red/blinking yellow )</li>
                </ul>
                <p><a href="#top">Back to top</a></p>
            </li>
        </ul>
    </li>
    <li><span><a id="pill"></a>Pill separator, &gt;=2 types of pill&nbsp;</span>
        <ul>
            <ul>
                <li>Count-down timer to decide when the types of pills. The time intervals can be reconfigured.</li>
                <li>The warning signal for not taking the pills in a certain time period. (similar to the snooze feature)</li>
                <li>The warning signal for insufficient pills in the pill storage unit(&lt;1 week needed amount of pills )</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="x_o"></a>X and O game</span>
        <ul>
            <ul>
                <li><span>The basic design of the X &amp; O game for two players using combinational logic. </span></li>
                <li><span>Design a simple strategy allowing a human-machine X &amp; O game.&nbsp;</span></li>
                <li>User-friendly display to identify win/lose/tie situations.</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="lock"></a>Digital Lock</span>
        <ul>
            <ul>
                <li><span>Set &amp; store the correct password with 4~10 digits using input buttons</span></li>
                <li><span>Enter the correct password to unlock using the same input buttons.&nbsp;</span></li>
                <li><span>Cool down period if the user entered multiple incorrect passwords.</span></li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="english_display"></a>LED display control for multiple combinations of English character(s)</span>
        <ul>
            <ul>
                <li><span>Store the letter for LED display in memory or using combination logic(not recommended). A~Z &amp; 0~9 is fine.</span></li>
                <li><span>Allow multiple patterns/colors for display(think of CATbus with rotation of RED-CLEMSON/RED-CENTRAL/GO TIGERS/BEAT XXX(based on a specific event))</span></li>
                <li>Long string display within the limited LED space(circularly rotate part of the word )</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="scoreboard"></a>Different kinds of scoreboards&amp;Billboard</span>
        <ul>
            <ul>
                <li><span>American Football</span></li>
                <li><span>Basketball</span></li>
                <li><span>High-performance player/Team player statistics.&nbsp;</span></li>
                <li><span>Other necessary display feature</span></li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="clocks"></a>Clock/timer/meters/alarm clock with functions</span>
        <ul>
            <ul>
                <li><span>Basic clock feature with hour/min/sec with the decimal display.</span></li>
                <li><span>Basic timer for counting down with set/reset/display.</span></li>
                <li><span>Basic meter for counting up with set/reset/display.</span></li>
                <li>Record lap-wise time.&nbsp;</li>
                <li>Alarm clock design.</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="vending"></a>Vending machine simulation</span>
        <ul>
            <ul>
                <li><span>Accept quarter/half-dollar/$1, $2, $5 bills. You can consider penny/dime/nickel, but it might be too complicated.&nbsp;</span></li>
                <li><span>Allow purchasing multiple types of merchandise.</span></li>
                <li><span>Give change if needed using comparison logic. Return bills if needed.&nbsp;&nbsp;</span></li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="elevator"></a>Elevator simulation</span>
        <ul>
            <ul>
                <li>Design the elevator for at least 5 floors.&nbsp;</li>
                <li>Users can push the up/down button to access the elevator.</li>
                <li>Consider possible override by firefighter/elevator operator.&nbsp;</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><span><a id="ic_testor"></a>Digital circuit functionality checker for multiple(&gt;=4 kinds of &gt;=4 input pins meaning full digital circuit)</span></span>
        <ul>
            <ul>
                <li>Feed in the Device Under Test(DUT) with all possible input vectors(multiple input pins) stored in the memory.</li>
                <li>Check the DUT's output with the designed output stored in the memory.</li>
                <li>Warning sign if the DUT has different functions and displays the malfunctioning input/output.</li>
                <li>Give hints for possible fixing methods with the proper display.</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="seq_gen"></a>Sequence Generator(Fibonacci) with display</span>
        <ul>
            <ul>
                <li><span>Generate the sequence by COMPUTATION using the given integrated counter value. </span></li>
                <li>Show the sequence and sequence types using the display.&nbsp;</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="stream_enc_dec"></a>Streaming channel encoder/decoder using simple Parity error correction code.</span></li>
    <li><span><span><a id="mem_test"></a>Memory&nbsp; tester:</span></span>
        <ul>
            <ul>
                <li>Create a RAM with read and write capability.</li>
                <li>Write in the custom meaningful data wtih bit-width 8 in two ways:
                    <ul>
                        <li>Initialize the value stored in the RAM(all 0 is the special case), you need to find your own possible meaning full initial values.</li>
                        <li>User custom data input (possibly with input/output pins or other good interface).</li>
                    </ul>
                </li>
                <li>Read the data from the RAM, and properly store and display.</li>
                <li>Users determine whether the current state is a read process or a write process. You can design your own read/write process patterns. Use LED indicator for interaction.</li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><a id="alu"></a>Simple ALU/processor design (may refer to CS61C from UC Berkeley)&nbsp;</span>
        <ul>
            <ul>
                <li>A typical instruction-based processor involves 5 stages: IF = Instruction Fetch, ID = Instruction Decode, EX = Execute, MEM = Memory access, WB = Register write back, refer to <a href="https://en.wikipedia.org/wiki/Instruction_pipelining" target="_blank" rel="noopener">https://en.wikipedia.org/wiki/Instruction_pipelining</a></li>
                <li><span>Here, having ID, EX, and WB stages using the gate-level design is doable. Having the EX stage is a plus. This design is required to have a clock signal.</span>
                    <ul>
                        <li><span>In the ID stage, you retrieve the instruction code from the register (D flip-flop)</span></li>
                        <li><span>In the EX stage, you perform the instruction (arithmetic/logic operations). You have already done something similar in the MSI circuit lab; here, you need to extend it to a larger context.&nbsp;</span></li>
                        <li><span>In the WB stage, you extract the computation result from the ALU, and display/store it in the way you want.&nbsp;</span></li>
                        <li>
                            <table style="border-collapse: collapse; width: 95.8525%; height: 59px;" border="1">
                                <caption>ALU instruction execution clock cycle-wise explanation</caption>
                                <tbody>
                                    <tr style="height: 30px;">
                                        <td style="width: 24.9764%; height: 30px; text-align: center;">clk 0 (ID stage)</td>
                                        <td style="width: 24.9764%; height: 30px; text-align: center;">clk 1~ -1&nbsp; (EX stage)</td>
                                        <td style="width: 24.9764%; height: 30px; text-align: center;">clk -1 (WB stage)</td>
                                    </tr>
                                    <tr style="height: 29px;">
                                        <td style="width: 24.9764%; height: 29px; text-align: center;">
                                            <p>Extract the data from the data register.</p>
                                            <p>Extract the instruction code from the instruction register.</p>
                                            <p>Both instruction &amp; data registers are connected with input pins.&nbsp;&nbsp;</p>
                                        </td>
                                        <td style="width: 24.9764%; height: 29px; text-align: center;">
                                            <p>Perform the computation within the ALU.</p>
                                            <p>It is possible the instruction may take multiple clock cycles. Here, at most, 3 clock cycles for computations are enough.&nbsp;</p>
                                        </td>
                                        <td style="width: 24.9764%; height: 29px; text-align: center;">
                                            <p>Extract the computation result from the ALU.</p>
                                            <p>Use the proper way to display (LED/7-seg)</p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </li>
                    </ul>
                </li>
                <li><span>Using MUX to instruct the processor for different operations for given operands.</span></li>
                <li><span>Possible operation include basic logic operation(AND/OR/XOR/XNOR etc) &amp; basic arithmetic operation(ADD/SUB/Multiplication/Mod operation/Exponential operation)</span></li>
                <li><span>You can also make the design interactive by highlighting the current operation stage the ALU is working at.&nbsp;</span></li>
                <li><span>Try to minimize the total number of gates/ICs (make some of the gates/ICs multi-functional)</span></li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
    <li><span><span><a id="buzzer"></a>Quiz buzzer design.</span></span></li>
    <li><a href="#top">Back to top</a></li>
    <li><span><span><a id="other"></a>Other related online resources.</span></span>
        <ul>
            <ul>
                <li><span>You can also refer to the playlist here for more details:</span><span> <a href="https://www.youtube.com/playlist?list=PLvjlcTfwDj4spSN4g3S8IHbqY4Qkb5LxP" target="_blank" rel="noopener">https://www.youtube.com/playlist?list=PLvjlcTfwDj4spSN4g3S8IHbqY4Qkb5LxP</a></span></li>
            </ul>
        </ul>
        <p><a href="#top">Back to top</a></p>
    </li>
</ul>
</aside>
</div>